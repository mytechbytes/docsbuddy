// Supabase Edge Function: send-reminders-whatsapp
//
// Cron-driven WhatsApp sender for due-date reminders — the `whatsapp` channel
// of notification_prefs. For every incomplete service (asset_dates row) whose
// days-to-due matches one of its notify_offsets today (or is due today), it
// messages every family member who has the channel enabled and a phone number.
//
// Idempotent: a notification_log row (asset_date_id, offset_days, 'whatsapp')
// is inserted BEFORE sending; the composite PK makes re-runs no-ops, so the
// cron can fire hourly without double-sending.
//
// Schedule it daily (see README.md). Secrets required (supabase secrets set):
//   WHATSAPP_ACCESS_TOKEN    — Meta WhatsApp Cloud API token
//   WHATSAPP_PHONE_NUMBER_ID — the sending phone-number id
//   WHATSAPP_TEMPLATE        — (optional) pre-approved template name; without
//                              it a plain text message is sent, which Meta only
//                              delivers inside an open 24h customer session
//   WHATSAPP_TEMPLATE_LANG   — (optional) template language code, default "en"
// Provided automatically by the platform:
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY

import { createClient } from "jsr:@supabase/supabase-js@2";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

const MS_PER_DAY = 86_400_000;

function isoDate(d: Date): string {
  return d.toISOString().substring(0, 10);
}

/// Whole days from today (UTC midnights) to a `YYYY-MM-DD` due date.
function daysLeft(due: string, now: Date): number {
  const [y, m, d] = due.split("-").map(Number);
  const dueUtc = Date.UTC(y, m - 1, d);
  const todayUtc = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
  return Math.round((dueUtc - todayUtc) / MS_PER_DAY);
}

async function sendWhatsApp(to: string, body: string): Promise<boolean> {
  const phoneId = Deno.env.get("WHATSAPP_PHONE_NUMBER_ID")!;
  const token = Deno.env.get("WHATSAPP_ACCESS_TOKEN")!;
  const template = Deno.env.get("WHATSAPP_TEMPLATE");
  const payload = template
    ? {
      messaging_product: "whatsapp",
      to,
      type: "template",
      template: {
        name: template,
        language: { code: Deno.env.get("WHATSAPP_TEMPLATE_LANG") ?? "en" },
        components: [{ type: "body", parameters: [{ type: "text", text: body }] }],
      },
    }
    : { messaging_product: "whatsapp", to, type: "text", text: { body } };

  const res = await fetch(`https://graph.facebook.com/v20.0/${phoneId}/messages`, {
    method: "POST",
    headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });
  if (!res.ok) console.error(`whatsapp send to ${to} failed: ${await res.text()}`);
  return res.ok;
}

/// Phones of family members who enabled the whatsapp channel.
async function whatsappRecipients(familyId: string): Promise<string[]> {
  const { data: members } = await admin
    .from("family_members").select("user_id").eq("family_id", familyId);
  const userIds = (members ?? []).map((m) => m.user_id as string);
  if (userIds.length === 0) return [];

  const { data: prefs } = await admin
    .from("notification_prefs").select("user_id")
    .in("user_id", userIds).contains("channels", ["whatsapp"]);
  const optedIn = (prefs ?? []).map((p) => p.user_id as string);
  if (optedIn.length === 0) return [];

  const { data: users } = await admin
    .from("users").select("phone").in("id", optedIn).not("phone", "is", null);
  return (users ?? []).map((u) => u.phone as string).filter(Boolean);
}

Deno.serve(async (_req) => {
  try {
    const now = new Date();

    // Candidate services: incomplete, due today .. +400d (covers any offset).
    const { data: dates, error } = await admin
      .from("asset_dates")
      .select("id, label, due_date, notify_offsets, assets(name, family_id)")
      .is("completed_at", null)
      .is("deleted_at", null)
      .gte("due_date", isoDate(now))
      .lte("due_date", isoDate(new Date(now.getTime() + 400 * MS_PER_DAY)));
    if (error) throw error;

    let sent = 0, skipped = 0;
    for (const d of dates ?? []) {
      const left = daysLeft(d.due_date as string, now);
      const offsets = new Set<number>([...((d.notify_offsets as number[]) ?? [30, 7, 1]), 0]);
      if (!offsets.has(left)) continue;

      // Claim the (reminder, offset, channel) slot first — PK conflict means
      // an earlier run already handled it.
      const { error: logErr } = await admin.from("notification_log").insert({
        asset_date_id: d.id,
        offset_days: left,
        channel: "whatsapp",
      });
      if (logErr) {
        skipped++;
        continue;
      }

      const asset = d.assets as { name?: string; family_id?: string } | null;
      if (!asset?.family_id) continue;
      const phones = await whatsappRecipients(asset.family_id);
      if (phones.length === 0) continue;

      const when = left === 0 ? "today" : `in ${left} day${left === 1 ? "" : "s"}`;
      const body = `DocsBuddy reminder: ${asset.name ?? "Asset"} — ${d.label} is due ${when} (${d.due_date}).`;
      const results = await Promise.all(phones.map((p) => sendWhatsApp(p, body)));
      sent += results.filter(Boolean).length;
    }

    return Response.json({ sent, deduped: skipped, scanned: (dates ?? []).length });
  } catch (e) {
    return Response.json({ error: String(e) }, { status: 500 });
  }
});
