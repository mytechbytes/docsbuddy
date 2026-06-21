// Supabase Edge Function: notify-family
//
// Sends a SILENT FCM data push to a family's devices when one member changes a
// reminder/asset/document — the server half of the local-first sync wake. The
// app receives it (foreground) and refreshes; background pushes just wake it.
//
// Trigger it with a Supabase Database Webhook (Dashboard → Database → Webhooks)
// on INSERT/UPDATE/DELETE of public.asset_dates / public.assets / public.documents,
// pointing at this function's URL. See README.md.
//
// Secrets required (supabase secrets set ...):
//   FIREBASE_SERVICE_ACCOUNT  — the full Firebase service-account JSON (string)
// Provided automatically by the platform:
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY

import { createClient } from "jsr:@supabase/supabase-js@2";
import { create } from "https://deno.land/x/djwt@v3.0.4/mod.ts";

interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: Record<string, unknown> | null;
  old_record: Record<string, unknown> | null;
}

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

function pemToPkcs8(pem: string): ArrayBuffer {
  const b64 = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s/g, "");
  const bin = atob(b64);
  const buf = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) buf[i] = bin.charCodeAt(i);
  return buf.buffer;
}

async function fcmAccessToken(sa: { client_email: string; private_key: string }): Promise<string> {
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToPkcs8(sa.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const now = Math.floor(Date.now() / 1000);
  const jwt = await create(
    { alg: "RS256", typ: "JWT" },
    {
      iss: sa.client_email,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    },
    key,
  );
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });
  const json = await res.json();
  if (!json.access_token) throw new Error(`token error: ${JSON.stringify(json)}`);
  return json.access_token;
}

/// Resolve the affected family_id from the changed row.
async function resolveFamilyId(p: WebhookPayload): Promise<string | null> {
  const row = p.record ?? p.old_record;
  if (!row) return null;
  if (typeof row.family_id === "string") return row.family_id;
  if (typeof row.asset_id === "string") {
    const { data } = await admin.from("assets").select("family_id").eq("id", row.asset_id).maybeSingle();
    return (data?.family_id as string) ?? null;
  }
  return null;
}

Deno.serve(async (req) => {
  try {
    const payload = (await req.json()) as WebhookPayload;
    const familyId = await resolveFamilyId(payload);
    if (!familyId) return Response.json({ skipped: "no family_id" });

    // Tokens of every member of that family.
    const { data: members } = await admin.from("family_members").select("user_id").eq("family_id", familyId);
    const userIds = (members ?? []).map((m) => m.user_id as string);
    if (userIds.length === 0) return Response.json({ sent: 0 });

    const { data: devices } = await admin.from("user_devices").select("fcm_token").in("user_id", userIds);
    const tokens = (devices ?? []).map((d) => d.fcm_token as string).filter(Boolean);
    if (tokens.length === 0) return Response.json({ sent: 0 });

    const sa = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!);
    const accessToken = await fcmAccessToken(sa);
    const projectId = sa.project_id as string;

    let sent = 0;
    await Promise.all(tokens.map(async (token) => {
      const res = await fetch(`https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`, {
        method: "POST",
        headers: { Authorization: `Bearer ${accessToken}`, "Content-Type": "application/json" },
        body: JSON.stringify({
          message: {
            token,
            // Data-only (silent) → the app decides whether to surface anything.
            data: { type: "sync", table: payload.table, family_id: familyId },
            android: { priority: "high" },
            apns: {
              headers: { "apns-priority": "5", "apns-push-type": "background" },
              payload: { aps: { "content-available": 1 } },
            },
          },
        }),
      });
      if (res.ok) sent++;
    }));

    return Response.json({ family_id: familyId, sent, total: tokens.length });
  } catch (e) {
    return Response.json({ error: String(e) }, { status: 500 });
  }
});
