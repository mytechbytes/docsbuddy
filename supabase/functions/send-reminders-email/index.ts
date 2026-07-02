// Supabase Edge Function: send-reminders-email
//
// Cron-driven email sender for due-date reminders — the `email` channel of
// notification_prefs. Same shape as send-reminders-whatsapp: for every
// incomplete service whose days-to-due matches one of its notify_offsets
// today (or is due today), it emails every family member who has the channel
// enabled, via the Resend API.
//
// Idempotent through notification_log's (asset_date_id, offset_days, 'email')
// primary key — the row is claimed BEFORE sending, so re-runs are no-ops.
//
// Secrets required (supabase secrets set):
//   RESEND_API_KEY — https://resend.com API key
//   EMAIL_FROM     — verified sender, e.g. "DocsBuddy <reminders@yourdomain>"
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

function daysLeft(due: string, now: Date): number {
  const [y, m, d] = due.split("-").map(Number);
  const dueUtc = Date.UTC(y, m - 1, d);
  const todayUtc = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
  return Math.round((dueUtc - todayUtc) / MS_PER_DAY);
}

async function sendEmail(to: string[], subject: string, html: string): Promise<boolean> {
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${Deno.env.get("RESEND_API_KEY")!}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ from: Deno.env.get("EMAIL_FROM")!, to, subject, html }),
  });
  if (!res.ok) console.error(`email send failed: ${await res.text()}`);
  return res.ok;
}

/// Emails of family members who enabled the email channel.
async function emailRecipients(familyId: string): Promise<string[]> {
  const { data: members } = await admin
    .from("family_members").select("user_id").eq("family_id", familyId);
  const userIds = (members ?? []).map((m) => m.user_id as string);
  if (userIds.length === 0) return [];

  const { data: prefs } = await admin
    .from("notification_prefs").select("user_id")
    .in("user_id", userIds).contains("channels", ["email"]);
  const optedIn = (prefs ?? []).map((p) => p.user_id as string);
  if (optedIn.length === 0) return [];

  const { data: users } = await admin.from("users").select("email").in("id", optedIn);
  return (users ?? []).map((u) => u.email as string).filter(Boolean);
}

Deno.serve(async (_req) => {
  try {
    const now = new Date();
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

      const { error: logErr } = await admin.from("notification_log").insert({
        asset_date_id: d.id,
        offset_days: left,
        channel: "email",
      });
      if (logErr) {
        skipped++;
        continue;
      }

      const asset = d.assets as { name?: string; family_id?: string } | null;
      if (!asset?.family_id) continue;
      const to = await emailRecipients(asset.family_id);
      if (to.length === 0) continue;

      const when = left === 0 ? "today" : `in ${left} day${left === 1 ? "" : "s"}`;
      const subject = `Reminder: ${asset.name ?? "Asset"} — ${d.label} due ${when}`;
      const html = `<p><strong>${asset.name ?? "Asset"}</strong> — ${d.label} is due <strong>${when}</strong> (${d.due_date}).</p><p>Open DocsBuddy to review or mark it done.</p>`;
      if (await sendEmail(to, subject, html)) sent++;
    }

    return Response.json({ sent, deduped: skipped, scanned: (dates ?? []).length });
  } catch (e) {
    return Response.json({ error: String(e) }, { status: 500 });
  }
});
