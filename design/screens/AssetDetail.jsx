// ASSET DETAIL — multi-reminder asset view
function AssetDetail() {
  const reminders = [
    { kind: 'pollution',    label: 'Pollution',       due: '07 Jun 2026', days: 15,  tone: 'red',   offsets: '30 · 7 · 1' },
    { kind: 'insurance',    label: 'Insurance',       due: '17 Jun 2026', days: 25,  tone: 'red',   offsets: '60 · 14 · 1' },
    { kind: 'amc',          label: 'AMC',             due: '22 Jul 2026', days: 60,  tone: 'green', offsets: '30 · 7' },
    { kind: 'tax',          label: 'Road Tax',        due: '01 Aug 2026', days: 70,  tone: 'green', offsets: '30 · 7 · 1' },
    { kind: 'service',      label: 'Service Due',     due: '20 Aug 2026', days: 89,  tone: 'green', offsets: '14 · 1' },
    { kind: 'fitness',      label: 'Fitness Cert.',   due: '12 Sep 2026', days: 112, tone: 'green', offsets: '30 · 7' },
  ];

  return (
    <ScreenBg>
      <CenteredHeader back dot />

      {/* Hero card */}
      <div style={{ margin: '0 18px 12px', background: '#fff', borderRadius: 16, padding: 12,
        display: 'flex', gap: 12, alignItems: 'center', border: '1px solid #eef2f8',
        boxShadow: '0 1px 4px rgba(15,30,55,0.04)' }}>
        <ImgPlaceholder label="bike" w={92} h={78} radius={10} tint="#e6efe8" />
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontWeight: 800, fontSize: 15, color: DB_COLORS.ink, lineHeight: 1.15 }}>Bike: Royal Enfield Classic 350</div>
          <div style={{ marginTop: 6 }}><CategoryChip label="Vehicles" /></div>
          <div style={{ fontSize: 11, color: DB_COLORS.muted, marginTop: 6 }}>
            6 reminders tracked · TN 01 AB 1234
          </div>
        </div>
      </div>

      {/* Next-up bar (driven by the most urgent reminder) */}
      <div style={{ margin: '0 18px', background: DB_COLORS.red, borderRadius: 12, padding: '12px 16px',
        display: 'flex', justifyContent: 'space-between', alignItems: 'center', color: '#fff' }}>
        <div>
          <div style={{ fontSize: 11, letterSpacing: '0.1em', fontWeight: 700, opacity: 0.85 }}>NEXT DUE</div>
          <div style={{ fontWeight: 800, fontSize: 18, marginTop: 2 }}>Pollution · 15 days</div>
        </div>
        <div style={{ fontSize: 12, opacity: 0.9, textAlign: 'right' }}>
          07 Jun 2026<br/><span style={{ opacity: 0.7 }}>Reminded 30/7/1</span>
        </div>
      </div>

      {/* All reminders list */}
      <div style={{ margin: '18px 18px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ fontWeight: 800, fontSize: 16, color: DB_COLORS.ink }}>All Reminders <span style={{ color: DB_COLORS.muted, fontWeight: 600 }}>· 6</span></div>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, padding: '6px 12px',
          background: '#0d1a2b', color: '#fff', borderRadius: 999, fontSize: 12, fontWeight: 700 }}>
          <Icon name="plus" size={12} color="#fff" /> Add
        </div>
      </div>

      <div style={{ margin: '10px 18px 0', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {reminders.map((r, i) => <ReminderListRow key={i} {...r} />)}
      </div>

      {/* Bills card */}
      <div style={{ margin: '18px 18px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ fontWeight: 800, fontSize: 16, color: DB_COLORS.ink }}>Documents <span style={{ color: DB_COLORS.muted, fontWeight: 600 }}>· 4</span></div>
        <div style={{ fontSize: 12, color: DB_COLORS.chipBlue, fontWeight: 700 }}>View all</div>
      </div>
      <div style={{ margin: '10px 18px 0', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {[
          { name: 'Pollution Certificate.pdf',  size: '1.2 MB' },
          { name: 'Insurance Policy.pdf',       size: '420 KB' },
        ].map((d, i) => (
          <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10,
            padding: '10px 12px', background: '#fff', border: '1px solid #eef2f8', borderRadius: 12,
            boxShadow: '0 1px 2px rgba(15,30,55,0.03)' }}>
            <div style={{ width: 30, height: 30, borderRadius: 8, background: '#eef3fb', display: 'grid', placeItems: 'center' }}>
              <Icon name="doc" size={16} color="#324159"/>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink }}>{d.name}</div>
              <div style={{ fontSize: 11, color: DB_COLORS.muted }}>{d.size}</div>
            </div>
            <button style={{ background: DB_COLORS.chipBlue, color: '#fff', border: 'none', height: 28,
              padding: '0 14px', borderRadius: 999, fontFamily: DB_FONT, fontWeight: 700, fontSize: 12 }}>View</button>
          </div>
        ))}
      </div>

      <div style={{ height: 16 }} />
    </ScreenBg>
  );
}

function ReminderListRow({ kind, label, due, days, tone, offsets }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 12,
      padding: '10px 12px', background: '#fff',
      border: '1px solid #eef2f8', borderRadius: 14,
      boxShadow: '0 1px 2px rgba(15,30,55,0.03)',
    }}>
      <IconBubble kind={kind} size={38} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontWeight: 700, fontSize: 13.5, color: DB_COLORS.ink }}>{label}</div>
        <div style={{ fontSize: 11, color: DB_COLORS.muted, marginTop: 2, display: 'flex', alignItems: 'center', gap: 6 }}>
          <Icon name="cal" size={11} color="#94a0b3" />
          <span>{due}</span>
          <span style={{ color: '#cfd6e2' }}>·</span>
          <Icon name="bell" size={11} color="#94a0b3" />
          <span>{offsets}d</span>
        </div>
      </div>
      <DayPill days={days} tone={tone} small />
    </div>
  );
}

Object.assign(window, { AssetDetail });
