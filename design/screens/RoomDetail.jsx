// ROOM DETAIL — single room with its appliances
function RoomDetail() {
  return (
    <ScreenBg>
      <AppHeader showLogo bell dot />

      {/* Hero image */}
      <div style={{ margin: '4px 18px 0' }}>
        <ImgPlaceholder label="kitchen photo" h={150} radius={14} tint="#e8d9c4" />
      </div>

      {/* Title row */}
      <div style={{ margin: '14px 18px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontWeight: 800, fontSize: 22, letterSpacing: '-0.01em' }}>My Kitchen Area</div>
          <div style={{ fontSize: 13, color: DB_COLORS.muted, marginTop: 4 }}>
            The heart of your home, managing <span style={{ color: DB_COLORS.ink, fontWeight: 700 }}>3 appliances</span>.
          </div>
        </div>
        <Icon name="edit" size={20} color="#324159" />
      </div>

      {/* Appliances heading */}
      <div style={{ margin: '24px 18px 10px', fontWeight: 800, fontSize: 18, letterSpacing: '-0.01em' }}>
        Appliances
      </div>

      {/* Grid */}
      <div style={{ margin: '0 18px', display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
        {[1,2,3].map(i => <ApplianceTile key={i} />)}
      </div>
    </ScreenBg>
  );
}

function ApplianceTile() {
  return (
    <div style={{
      background: '#fff', borderRadius: 14, padding: 12,
      border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)',
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
      position: 'relative',
    }}>
      <div style={{ position: 'absolute', top: 8, right: 8, width: 8, height: 8, borderRadius: 999, background: '#dde2ea' }}/>
      <IconBubble kind="leaf" size={42} />
      <div style={{ textAlign: 'center', lineHeight: 1.2 }}>
        <div style={{ fontWeight: 700, fontSize: 11.5, color: DB_COLORS.ink }}>Bike: Pollution</div>
        <div style={{ fontSize: 10, color: DB_COLORS.muted }}>Vehicles</div>
      </div>
      <DayPill days={15} tone="red" small />
    </div>
  );
}

Object.assign(window, { RoomDetail });
