-- ============================================================================
-- 0007 — WhatsApp reminder channel (design-gap decision, screen 15)
--
-- channels/channel are free-form text so no type change is needed; this
-- migration records 'whatsapp' as a supported value. Delivery is handled by
-- the `send-reminders-whatsapp` Edge Function (cron-driven), which dedups
-- through notification_log's (asset_date_id, offset_days, channel) PK and
-- sends to `users.phone` (E.164) for members whose prefs enable the channel.
-- ============================================================================

comment on column public.notification_prefs.channels is
  'Enabled delivery channels: push | local | email | whatsapp';

comment on column public.notification_log.channel is
  'Delivery channel the reminder went out on: push | local | email | whatsapp';
