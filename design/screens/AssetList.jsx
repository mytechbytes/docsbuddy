// ASSET LIST — Searchable list of registered assets
function AssetList() {
  const items = [
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
    { name: 'Iphone 15 Pro',                   cat: 'Smartphone', kind: 'phone' },
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
    { name: 'Iphone 15 Pro',                   cat: 'Smartphone', kind: 'phone' },
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
    { name: 'Bike: Royal Enfield Classic 350', cat: 'Vehicles', kind: 'bike' },
  ];

  return (
    <ScreenBg>
      <CenteredHeader back dot />

      <SearchBar />

      <div style={{ padding: '0 18px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {items.map((it, i) => (
          <AssetRow key={i} {...it} />
        ))}
      </div>
    </ScreenBg>
  );
}

function AssetRow({ name, cat, kind }) {
  const tint = kind === 'phone' ? '#e3e4ec' : '#dde9e2';
  return (
    <div style={{
      background: '#fff', borderRadius: 14, padding: 10,
      display: 'flex', alignItems: 'center', gap: 12,
      boxShadow: '0 1px 4px rgba(15,30,55,0.04)',
      border: '1px solid #eef2f8',
    }}>
      <ImgPlaceholder label={kind} w={64} h={48} radius={8} tint={tint} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontWeight: 700, fontSize: 13.5, color: DB_COLORS.ink, marginBottom: 4, lineHeight: 1.2 }}>{name}</div>
        <CategoryChip label={cat} />
      </div>
    </div>
  );
}

Object.assign(window, { AssetList });
