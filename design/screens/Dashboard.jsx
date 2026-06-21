// DASHBOARD — DocsBuddy main home screen
function Dashboard() {
  return (
    <ScreenBg>
      <AppHeader showLogo bell dot avatar />

      {/* 4 stat cards in 2x2 grid */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, padding: '6px 18px 4px' }}>
        <StatCard label="Active Invoices" value="23" icon="doc-fill" gradient={DB_COLORS.cardNavy} textLight />
        <StatCard label="Secured"         value="23" icon="shield-fill" gradient={DB_COLORS.cardTeal} textLight />
        <StatCard label="Expiring Soon"   value="23" icon="hourglass"   gradient={DB_COLORS.cardSky}  textLight={false} />
        <StatCard label="Expired"         value="23" icon="alert"       gradient={DB_COLORS.cardRose} textLight={false} />
      </div>

      {/* Section title */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '22px 22px 12px' }}>
        <div style={{ fontWeight: 800, fontSize: 22, letterSpacing: '-0.01em' }}>Upcoming Expirations</div>
        <Icon name="filter" size={20} color="#324159" />
      </div>

      {/* Combo card — featured + nested list */}
      <div style={{ margin: '0 18px', background: '#fff', borderRadius: 16, padding: 14,
        boxShadow: '0 2px 8px rgba(15,30,55,0.04)', border: '1px solid #eef2f8' }}>
        {/* Featured row */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '4px 4px 14px' }}>
          <ImgPlaceholder label="bike" w={62} h={50} radius={10} tint="#e6efe8" />
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontWeight: 700, fontSize: 14.5, color: DB_COLORS.ink, marginBottom: 2 }}>Bike: Royal Enfield Classic 350</div>
            <div style={{ fontSize: 12, color: DB_COLORS.muted }}>Vehicles</div>
          </div>
          <DayPill days={45} tone="green" />
        </div>

        {/* Nested reminder rows — varied types per asset */}
        {[
          { icon: 'pollution', title: 'Bike: Pollution', cat: 'Vehicles', d: 15, tone: 'red' },
          { icon: 'insurance', title: 'Bike: Insurance', cat: 'Vehicles', d: 25, tone: 'red' },
          { icon: 'amc',       title: 'Bike: AMC',       cat: 'Vehicles', d: 60, tone: 'green' },
          { icon: 'tax',       title: 'Bike: Road Tax',  cat: 'Vehicles', d: 70, tone: 'green' },
        ].map((r, i) => (
          <ReminderRow key={i} {...r} />
        ))}

        {/* Footer of card */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 6px 2px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: DB_COLORS.ink2 }}>
            <Icon name="clip" size={18} color="#324159" />
            <span style={{ fontWeight: 600, fontSize: 13 }}>4 Docs</span>
          </div>
          <Icon name="chevrons-up" size={22} color="#5da9ce" />
        </div>
      </div>

      {/* FAB */}
      <div style={{ position: 'absolute', right: 22, bottom: 48, width: 56, height: 56, borderRadius: 999,
        background: '#2476e8', display: 'grid', placeItems: 'center',
        boxShadow: '0 8px 22px rgba(36,118,232,0.45)' }}>
        <Icon name="plus" size={26} color="#fff" />
      </div>
    </ScreenBg>
  );
}

function StatCard({ label, value, icon, gradient, textLight }) {
  const ink = textLight ? '#ffffff' : DB_COLORS.ink;
  const sub = textLight ? 'rgba(255,255,255,0.85)' : DB_COLORS.ink;
  return (
    <div style={{
      background: `linear-gradient(135deg, ${gradient[0]} 0%, ${gradient[1]} 100%)`,
      borderRadius: 18, padding: '16px 16px 14px', minHeight: 132,
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
      color: ink, position: 'relative', overflow: 'hidden',
      boxShadow: '0 4px 14px rgba(15,30,55,0.08)',
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div style={{ fontWeight: 700, fontSize: 14, lineHeight: 1.2 }}>{label}</div>
        <Icon name={icon} size={20} color={ink} />
      </div>
      <div style={{ fontWeight: 800, fontSize: 36, letterSpacing: '-0.02em', lineHeight: 1, color: sub }}>{value}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 4, fontSize: 12, fontWeight: 600, opacity: 0.95 }}>
        View <Icon name="chevron-right" size={14} color={ink} />
      </div>
    </div>
  );
}

function ReminderRow({ icon, title, cat, d, tone }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 12,
      padding: '10px 8px', margin: '4px 0',
      borderRadius: 999,
      background: tone === 'green' ? '#f3faf5' : '#fafbfd',
      border: `1px solid ${tone === 'green' ? '#e0f0e6' : '#eef1f6'}`,
    }}>
      <IconBubble kind={icon} size={32} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, lineHeight: 1.2 }}>{title}</div>
        <div style={{ fontSize: 11, color: DB_COLORS.muted, marginTop: 1 }}>{cat}</div>
      </div>
      <DayPill days={d} tone={tone} small />
    </div>
  );
}

Object.assign(window, { Dashboard });
