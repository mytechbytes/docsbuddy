// ROOMS — list of location areas with cover images + item count
function Rooms() {
  const rooms = [
    { name: 'My Kitchen Area', items: 3, tint: '#e8d9c4', label: 'kitchen photo' },
    { name: 'My Bedroom Area', items: 1, tint: '#dee6ec', label: 'bedroom photo' },
    { name: 'My Living Area',  items: 3, tint: '#dcd9e8', label: 'living photo'  },
  ];
  return (
    <ScreenBg>
      <AppHeader showLogo bell dot />

      {/* Add new room */}
      <div style={{ margin: '4px 18px 14px', background: '#fff', borderRadius: 14,
        padding: '14px 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)' }}>
        <div style={{ fontWeight: 600, color: DB_COLORS.ink, fontSize: 14.5 }}>Add a new room</div>
        <Icon name="plus-circle" size={22} color="#324159" />
      </div>

      <div style={{ padding: '0 18px', display: 'flex', flexDirection: 'column', gap: 14 }}>
        {rooms.map((r, i) => <RoomCard key={i} {...r} />)}
      </div>
    </ScreenBg>
  );
}

function RoomCard({ name, items, tint, label }) {
  return (
    <div style={{ background: '#fff', borderRadius: 16, overflow: 'hidden',
      border: '1px solid #eef2f8', boxShadow: '0 2px 8px rgba(15,30,55,0.05)' }}>
      <div style={{ padding: 10 }}>
        <ImgPlaceholder label={label} h={130} radius={10} tint={tint} />
      </div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '4px 16px 16px' }}>
        <div>
          <div style={{ fontWeight: 800, fontSize: 16, color: DB_COLORS.ink }}>{name}</div>
          <div style={{ fontSize: 12, color: DB_COLORS.muted, marginTop: 2 }}>{items} Items Registered</div>
        </div>
        <div style={{ width: 32, height: 32, borderRadius: 999, background: '#f1f4f9',
          display: 'grid', placeItems: 'center' }}>
          <Icon name="chevron-right" size={16} color="#324159" />
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { Rooms });
