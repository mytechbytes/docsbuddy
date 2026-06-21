// APPLIANCE PICKER — long list of selectable appliance types
function AppliancePicker() {
  const items = [
    { label: 'Air Conditioners', glyph: 'ac' },
    { label: 'Air Purifier',     glyph: 'purifier' },
    { label: 'Air Dresser',      glyph: 'dresser' },
    { label: 'Air Purifier',     glyph: 'purifier' },
    { label: 'Air Dresser',      glyph: 'dresser' },
    { label: 'Air Conditioners', glyph: 'ac' },
    { label: 'Air Dresser',      glyph: 'dresser' },
    { label: 'Air fryer',        glyph: 'fryer' },
  ];

  return (
    <ScreenBg>
      {/* simple back / close header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', padding: '14px 22px 6px' }}>
        <Icon name="back"  size={22}/>
        <Icon name="close" size={22}/>
      </div>
      <div style={{ padding: '10px 22px 4px', fontWeight: 800, fontSize: 22, letterSpacing: '-0.01em' }}>
        Select Your Appliances
      </div>
      <SearchBar />

      <div style={{ margin: '0 18px', background: '#fff', borderRadius: 16,
        boxShadow: '0 1px 4px rgba(15,30,55,0.04)', border: '1px solid #eef2f8',
        overflow: 'hidden' }}>
        {items.map((it, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'center', gap: 14, padding: '14px 18px',
            borderBottom: i < items.length - 1 ? '1px solid #f0f3f8' : 'none',
          }}>
            <ApplianceGlyph kind={it.glyph} />
            <div style={{ fontWeight: 600, fontSize: 14.5, color: DB_COLORS.ink }}>{it.label}</div>
          </div>
        ))}
      </div>
    </ScreenBg>
  );
}

// stylised small appliance glyphs (simple rectangles, not detailed)
function ApplianceGlyph({ kind }) {
  const W = 36, H = 28;
  switch (kind) {
    case 'ac': return (
      <svg width={W} height={H} viewBox="0 0 36 28">
        <rect x="2" y="6" width="32" height="11" rx="2.5" fill="#dde2ea" stroke="#a9b3c0" strokeWidth="1"/>
        <path d="M5 17v3M11 17v3M17 17v3M23 17v3M29 17v3" stroke="#8b95a4" strokeWidth="1.4" strokeLinecap="round"/>
      </svg>
    );
    case 'purifier': return (
      <svg width={W} height={H} viewBox="0 0 36 28">
        <rect x="9" y="3" width="18" height="23" rx="3" fill="#eaeef4" stroke="#a9b3c0" strokeWidth="1"/>
        <circle cx="18" cy="14" r="4" fill="none" stroke="#8b95a4" strokeWidth="1.2"/>
        <rect x="13" y="22" width="10" height="1.5" rx="0.75" fill="#8b95a4"/>
      </svg>
    );
    case 'dresser': return (
      <svg width={W} height={H} viewBox="0 0 36 28">
        <rect x="7" y="10" width="22" height="14" rx="3" fill="#d5e3ec" stroke="#8aabbc" strokeWidth="1"/>
        <path d="M11 10c0-4 3-6 7-6s7 2 7 6" fill="#f1c4b5" stroke="#c98d77" strokeWidth="1"/>
      </svg>
    );
    case 'fryer': return (
      <svg width={W} height={H} viewBox="0 0 36 28">
        <path d="M10 6h16v18H10z" fill="#e6e9ef" stroke="#8b95a4" strokeWidth="1"/>
        <rect x="13" y="9" width="10" height="6" rx="1.5" fill="#cdd4de"/>
        <circle cx="18" cy="20" r="1.5" fill="#8b95a4"/>
      </svg>
    );
    default: return <div style={{ width: W, height: H, background: '#eee' }}/>;
  }
}

Object.assign(window, { AppliancePicker });
