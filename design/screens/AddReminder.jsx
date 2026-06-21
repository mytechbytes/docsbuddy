// ADD REMINDER — choose type, set date, configure notification offsets
function AddReminder() {
  const types = [
    { kind: 'insurance' },
    { kind: 'pollution' },
    { kind: 'amc' },
    { kind: 'tax' },
    { kind: 'service' },
    { kind: 'warranty' },
    { kind: 'fitness' },
    { kind: 'registration' },
  ];
  const selectedKind = 'insurance';

  return (
    <ScreenBg>
      <div style={{ display: 'flex', justifyContent: 'space-between', padding: '14px 22px 6px' }}>
        <Icon name="back" size={22}/>
        <Icon name="close" size={22}/>
      </div>
      <div style={{ padding: '8px 22px 4px', fontWeight: 800, fontSize: 22, letterSpacing: '-0.01em' }}>
        Add Reminder
      </div>
      <div style={{ padding: '0 22px 14px', fontSize: 13, color: DB_COLORS.muted }}>
        For <b style={{ color: DB_COLORS.ink }}>Bike: Royal Enfield Classic 350</b>
      </div>

      {/* Type grid */}
      <div style={{ padding: '0 22px' }}>
        <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, marginBottom: 10 }}>Reminder Type</div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10 }}>
          {types.map(t => (
            <TypeTile key={t.kind} kind={t.kind} selected={t.kind === selectedKind} />
          ))}
        </div>
      </div>

      {/* Date field */}
      <div style={{ padding: '20px 22px 0' }}>
        <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, marginBottom: 6 }}>
          Due Date<span style={{ color: '#d24b54' }}>*</span>
        </div>
        <div style={{
          height: 48, background: '#fff', borderRadius: 12, display: 'flex', alignItems: 'center',
          padding: '0 14px', gap: 10, border: '1px solid #e6ebf3', boxShadow: '0 1px 2px rgba(15,30,55,0.03)',
        }}>
          <Icon name="cal" size={16} color="#324159" />
          <div style={{ flex: 1, fontSize: 14, color: DB_COLORS.ink, fontWeight: 600 }}>17 / 06 / 2026</div>
          <div style={{ fontSize: 11, color: DB_COLORS.muted }}>in 25 days</div>
        </div>
      </div>

      {/* Recurrence */}
      <div style={{ padding: '14px 22px 0' }}>
        <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, marginBottom: 6, display: 'flex', alignItems: 'center', gap: 6 }}>
          <Icon name="repeat" size={14} color="#324159" /> Repeats
        </div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {['Never','Monthly','Quarterly','Half-yearly','Yearly'].map((o,i) => (
            <div key={i} style={{
              padding: '8px 14px', borderRadius: 999, fontSize: 12, fontWeight: 700,
              background: o === 'Yearly' ? DB_COLORS.ink : '#fff',
              color: o === 'Yearly' ? '#fff' : DB_COLORS.ink2,
              border: o === 'Yearly' ? 'none' : '1px solid #dde3ed',
            }}>{o}</div>
          ))}
        </div>
      </div>

      {/* Notification thresholds */}
      <div style={{ padding: '18px 22px 0' }}>
        <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, marginBottom: 6, display: 'flex', alignItems: 'center', gap: 6 }}>
          <Icon name="bell" size={14} color="#324159" /> Notify me
        </div>
        <div style={{ fontSize: 11, color: DB_COLORS.muted, marginBottom: 10 }}>
          Push notification &amp; reminder to all family members
        </div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {[
            { v: '60d', on: false }, { v: '30d', on: true }, { v: '14d', on: true },
            { v: '7d', on: true },   { v: '3d', on: false }, { v: '1d', on: true },
          ].map((p,i) => (
            <div key={i} style={{
              padding: '8px 14px', borderRadius: 999, fontSize: 12, fontWeight: 700,
              background: p.on ? DB_COLORS.chipBlue : '#fff',
              color: p.on ? '#fff' : DB_COLORS.ink2,
              border: p.on ? 'none' : '1px solid #dde3ed',
              display: 'inline-flex', alignItems: 'center', gap: 4,
            }}>
              {p.on && <span style={{ width: 4, height: 4, borderRadius: 999, background: '#fff' }}/>}
              {p.v} before
            </div>
          ))}
        </div>
      </div>

      {/* Attach doc */}
      <div style={{ padding: '18px 22px 0' }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px',
          background: '#fff', border: '1px dashed #cfd6e2', borderRadius: 12,
        }}>
          <div style={{ width: 32, height: 32, borderRadius: 8, background: '#eef3fb', display: 'grid', placeItems: 'center' }}>
            <Icon name="clip" size={16} color="#324159" />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink }}>Attach document</div>
            <div style={{ fontSize: 11, color: DB_COLORS.muted }}>Insurance policy, receipt, photo…</div>
          </div>
          <Icon name="chevron-right" size={16} color="#94a0b3" />
        </div>
      </div>

      {/* Buttons */}
      <div style={{ display: 'flex', gap: 12, padding: '20px 22px 12px' }}>
        <button style={{
          flex: 1, height: 50, borderRadius: 12, border: '1.5px solid #cfd6e2',
          background: 'transparent', color: DB_COLORS.ink, fontFamily: DB_FONT,
          fontWeight: 700, fontSize: 15,
        }}>Cancel</button>
        <button style={{
          flex: 1, height: 50, borderRadius: 12, border: 'none',
          background: '#0d1a2b', color: '#fff', fontFamily: DB_FONT,
          fontWeight: 700, fontSize: 15,
        }}>Save Reminder</button>
      </div>
    </ScreenBg>
  );
}

function TypeTile({ kind, selected }) {
  const p = REMINDER_TYPES[kind];
  return (
    <div style={{
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
      padding: '12px 6px',
      background: '#fff', borderRadius: 12,
      border: selected ? `2px solid ${p.fg}` : '1px solid #e6ebf3',
      boxShadow: selected ? `0 0 0 4px ${p.bg}` : '0 1px 2px rgba(15,30,55,0.03)',
    }}>
      <IconBubble kind={kind} size={36} />
      <div style={{ fontWeight: 700, fontSize: 11, color: DB_COLORS.ink, textAlign: 'center' }}>{p.label}</div>
    </div>
  );
}

Object.assign(window, { AddReminder });
