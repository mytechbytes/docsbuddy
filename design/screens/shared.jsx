// Shared design tokens + atoms for all DocsBuddy screens
const DB_COLORS = {
  bg: '#f4f6fa',
  paper: '#ffffff',
  ink: '#0d1a2b',
  ink2: '#324159',
  muted: '#6b7891',
  line: '#e7ebf2',
  chipBlue: '#2476e8',
  green: '#1ea765',
  greenSoft: '#e3f5e7',
  greenLeaf: '#3fa75c',
  red: '#d24b54',
  redSoft: '#fdebec',
  shieldBlue: '#3a8fa3',
  cardNavy: ['#1f3a5f', '#2a4a6e'],
  cardTeal: ['#2a7f9e', '#3aa1bb'],
  cardSky:  ['#a8c2d2', '#c0d3df'],
  cardRose: ['#e88088', '#f0a0a5'],
};

const DB_FONT = '"Plus Jakarta Sans", -apple-system, system-ui, sans-serif';

// ─── Brand logo ───────────────────────────────────────────────
function DBLogo({ size = 19 }) {
  return (
    <div style={{ fontFamily: DB_FONT, fontWeight: 800, fontSize: size, letterSpacing: '-0.02em', display: 'flex' }}>
      <span style={{ color: DB_COLORS.ink }}>Docs</span>
      <span style={{ color: '#9aa3b2' }}>Buddy</span>
    </div>
  );
}

// ─── Header used on most screens ──────────────────────────────
function AppHeader({ showLogo = true, title, back = false, close = false, search = true, bell = true, avatar = true, dot = false, right }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '14px 22px 10px', gap: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, minWidth: 0 }}>
        {back && <Icon name="back" />}
        {showLogo && !title && <DBLogo />}
        {title && <div style={{ fontFamily: DB_FONT, fontWeight: 800, fontSize: 17, color: DB_COLORS.ink }}>{title}</div>}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 18 }}>
        {right}
        {search && <Icon name="search" />}
        {bell && <div style={{ position: 'relative' }}>
          <Icon name="bell" />
          {dot && <div style={{ position: 'absolute', top: -1, right: -1, width: 8, height: 8, borderRadius: 999, background: '#e63946', border: '2px solid white' }} />}
        </div>}
        {avatar && <Avatar />}
        {close && <Icon name="close" />}
      </div>
    </div>
  );
}

// Sub-header variant: logo centered with back + actions
function CenteredHeader({ back = true, title, bell = true, avatar = true, dot = false }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '14px 22px 10px',
    }}>
      <div style={{ width: 32 }}>{back && <Icon name="back" />}</div>
      <div>{title ? <div style={{ fontFamily: DB_FONT, fontWeight: 800, fontSize: 17, color: DB_COLORS.ink }}>{title}</div> : <DBLogo size={18} />}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
        {bell && <div style={{ position: 'relative' }}>
          <Icon name="bell" />
          {dot && <div style={{ position: 'absolute', top: -1, right: -1, width: 8, height: 8, borderRadius: 999, background: '#e63946', border: '2px solid white' }} />}
        </div>}
        {avatar && <Avatar />}
      </div>
    </div>
  );
}

// ─── Avatar (placeholder) ─────────────────────────────────────
function Avatar({ size = 28 }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: 999, overflow: 'hidden',
      background: 'linear-gradient(135deg, #f1c27d 0%, #d68b5c 60%, #5e4b3a 100%)',
      border: '1.5px solid #fff', boxShadow: '0 0 0 1px rgba(0,0,0,0.05)',
      position: 'relative',
    }}>
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 50% 35%, rgba(255,255,255,0.45), transparent 35%)' }}/>
    </div>
  );
}

// ─── Day-remaining pill ───────────────────────────────────────
function DayPill({ days, tone, small = false }) {
  const t = tone || (days >= 30 ? 'green' : 'red');
  const bg = t === 'green' ? DB_COLORS.green : DB_COLORS.red;
  return (
    <div style={{
      background: bg, color: '#fff', fontFamily: DB_FONT,
      padding: small ? '5px 12px' : '9px 16px',
      borderRadius: 999, fontWeight: 700, fontSize: small ? 12 : 14,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      minWidth: small ? 44 : 60,
    }}>{days}d</div>
  );
}

// ─── Category chip (blue tag like "Vehicles") ─────────────────
function CategoryChip({ label, color = DB_COLORS.chipBlue }) {
  return (
    <div style={{
      display: 'inline-flex', background: color, color: '#fff',
      padding: '3px 12px', borderRadius: 6, fontWeight: 600, fontSize: 11,
      fontFamily: DB_FONT, letterSpacing: '0.01em',
    }}>{label}</div>
  );
}

// ─── Reminder-type palette: one per kind of due date ──────────
const REMINDER_TYPES = {
  pollution: { label: 'Pollution', bg: '#e3f5e7', fg: '#3fa75c', icon: 'leaf' },
  insurance: { label: 'Insurance', bg: '#e1f1f5', fg: '#3a8fa3', icon: 'shield' },
  amc:       { label: 'AMC',       bg: '#fdf1e0', fg: '#c68318', icon: 'wrench' },
  service:   { label: 'Service',   bg: '#fbe7ee', fg: '#c63d75', icon: 'gear' },
  tax:       { label: 'Tax',       bg: '#e8e4f7', fg: '#6c52c2', icon: 'rupee' },
  warranty:  { label: 'Warranty',  bg: '#dfecff', fg: '#2476e8', icon: 'badge' },
  registration: { label: 'Registration', bg: '#e5efe8', fg: '#4d8a64', icon: 'doc' },
  fitness:   { label: 'Fitness',   bg: '#fdf1e0', fg: '#c68318', icon: 'pulse' },
  leaf:      { label: 'Pollution', bg: '#e3f5e7', fg: '#3fa75c', icon: 'leaf' },
  shield:    { label: 'Insurance', bg: '#e1f1f5', fg: '#3a8fa3', icon: 'shield' },
  spark:     { label: 'Service',   bg: '#fdf1e0', fg: '#c68318', icon: 'spark' },
};

// ─── Icon bubble (coloured circle per reminder type) ──────────
function IconBubble({ kind = 'leaf', size = 36 }) {
  const p = REMINDER_TYPES[kind] || REMINDER_TYPES.leaf;
  return (
    <div style={{
      width: size, height: size, borderRadius: 999,
      background: p.bg, display: 'grid', placeItems: 'center', flex: '0 0 auto',
    }}>
      <Icon name={p.icon} color={p.fg} size={size * 0.5} />
    </div>
  );
}

// ─── Search field ─────────────────────────────────────────────
function SearchBar({ placeholder = 'Search Your Appliance' }) {
  return (
    <div style={{
      margin: '6px 22px 14px',
      height: 48, background: '#fff', borderRadius: 12,
      display: 'flex', alignItems: 'center', gap: 10, padding: '0 16px',
      boxShadow: '0 1px 2px rgba(15,30,55,0.04)',
      border: '1px solid #ecf0f6',
    }}>
      <Icon name="search" size={16} color="#94a0b3" />
      <div style={{ fontFamily: DB_FONT, color: '#a3acba', fontSize: 14 }}>{placeholder}</div>
    </div>
  );
}

// ─── Screen background wrapper ────────────────────────────────
function ScreenBg({ children, dark = false }) {
  return (
    <div style={{
      background: dark ? DB_COLORS.ink : DB_COLORS.bg,
      minHeight: '100%', fontFamily: DB_FONT, color: DB_COLORS.ink,
      paddingTop: 44, // status bar
      paddingBottom: 40, // home indicator
    }}>{children}</div>
  );
}

// ─── Image placeholder (subtle striped) ───────────────────────
function ImgPlaceholder({ label, w = '100%', h = 120, radius = 12, tint = '#e6ecf3' }) {
  return (
    <div style={{
      width: w, height: h, borderRadius: radius,
      background: `repeating-linear-gradient(135deg, ${tint} 0 8px, ${shade(tint, -4)} 8px 16px)`,
      display: 'grid', placeItems: 'center', overflow: 'hidden',
      fontFamily: 'JetBrains Mono, monospace', fontSize: 10, color: '#7b8699',
      border: '1px solid rgba(15,30,55,0.04)',
    }}>{label}</div>
  );
}
function shade(hex, p) {
  // simple darken/lighten
  const c = hex.replace('#',''); const r = parseInt(c.slice(0,2),16), g = parseInt(c.slice(2,4),16), b = parseInt(c.slice(4,6),16);
  const k = (v) => Math.max(0, Math.min(255, v + p));
  return `rgb(${k(r)},${k(g)},${k(b)})`;
}

// ─── Iconography (small, line-style) ─────────────────────────
function Icon({ name, size = 20, color = '#0d1a2b' }) {
  const sw = 1.6;
  const common = { width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: color, strokeWidth: sw, strokeLinecap: 'round', strokeLinejoin: 'round' };
  switch (name) {
    case 'search': return <svg {...common}><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>;
    case 'bell':   return <svg {...common}><path d="M6 8a6 6 0 1 1 12 0c0 5 2 6 2 7H4c0-1 2-2 2-7z"/><path d="M10 20a2 2 0 0 0 4 0"/></svg>;
    case 'back':   return <svg {...common}><path d="m14 6-6 6 6 6"/></svg>;
    case 'close':  return <svg {...common}><path d="m6 6 12 12M18 6 6 18"/></svg>;
    case 'filter': return <svg {...common}><path d="M3 5h18l-7 9v6l-4-2v-4z"/></svg>;
    case 'plus':   return <svg {...common}><path d="M12 5v14M5 12h14"/></svg>;
    case 'plus-circle': return <svg {...common}><circle cx="12" cy="12" r="9"/><path d="M12 8v8M8 12h8"/></svg>;
    case 'chevron-right': return <svg {...common}><path d="m9 6 6 6-6 6"/></svg>;
    case 'chevrons-up':   return <svg {...common} stroke={color}><path d="m7 14 5-5 5 5M7 19l5-5 5 5"/></svg>;
    case 'clip':   return <svg {...common}><path d="M21 12.5 12.5 21a5 5 0 0 1-7-7l9-9a3.5 3.5 0 1 1 5 5l-9 9a2 2 0 1 1-3-3l8-8"/></svg>;
    case 'leaf':   return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M20 4c-7 0-13 4-13 12 0 2 .6 3.5 1.6 4.4l1-1c-.4-.6-.6-1.7-.6-3.4 0-6 4-9 9-9.4-3 1-7 3-9 7 3-3 7-4 11-4z"/></svg>;
    case 'shield': return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2 4 5v7c0 5 3.5 8.5 8 10 4.5-1.5 8-5 8-10V5l-8-3z"/><path d="m8.5 12 2.5 2.5L16 10" stroke="#fff" strokeWidth="1.8" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>;
    case 'spark':  return <svg {...common}><path d="M12 3v3M12 18v3M3 12h3M18 12h3M5.6 5.6l2.1 2.1M16.3 16.3l2.1 2.1M5.6 18.4l2.1-2.1M16.3 7.7l2.1-2.1"/></svg>;
    case 'doc':    return <svg {...common}><path d="M7 3h8l4 4v14H7z"/><path d="M15 3v4h4"/></svg>;
    case 'doc-fill': return <svg width={size} height={size} viewBox="0 0 24 24" fill="none"><path d="M7 3h8l4 4v14H7z" fill="rgba(255,255,255,0.18)" stroke="#fff" strokeWidth="1.6" strokeLinejoin="round"/><path d="M15 3v4h4" stroke="#fff" strokeWidth="1.6" strokeLinejoin="round"/><path d="M10 12h6M10 16h4" stroke="#fff" strokeWidth="1.6" strokeLinecap="round"/></svg>;
    case 'shield-fill': return <svg width={size} height={size} viewBox="0 0 24 24" fill="none"><path d="M12 2 4 5v7c0 5 3.5 8.5 8 10 4.5-1.5 8-5 8-10V5l-8-3z" stroke="#fff" strokeWidth="1.6" fill="rgba(255,255,255,0.18)" strokeLinejoin="round"/></svg>;
    case 'hourglass': return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth={sw}><path d="M7 3h10M7 21h10M8 3c0 4 8 5 8 9s-8 5-8 9M16 3c0 4-8 5-8 9s8 5 8 9"/></svg>;
    case 'alert':  return <svg {...common}><circle cx="12" cy="12" r="9"/><path d="M12 7v6M12 16.5v.5"/></svg>;
    case 'cam':    return <svg {...common}><path d="M3 8h3l1.5-2h9L18 8h3v11H3z"/><circle cx="12" cy="13" r="3.5"/></svg>;
    case 'cal-plus': return <svg {...common}><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4M12 13v5M9.5 15.5h5"/></svg>;
    case 'cal':    return <svg {...common}><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 9h18M8 3v4M16 3v4"/></svg>;
    case 'edit':   return <svg {...common}><path d="M4 20h4l10-10-4-4L4 16zM14 6l4 4"/></svg>;
    case 'caret':  return <svg {...common}><path d="m6 9 6 6 6-6"/></svg>;
    case 'wrench': return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M21.7 6.3a5 5 0 0 1-6.5 6.5L7 21a2.1 2.1 0 0 1-3-3l8.2-8.2a5 5 0 0 1 6.5-6.5l-3 3 1.5 1.5 1.5 1.5 3-3z"/></svg>;
    case 'gear':   return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth={sw} strokeLinejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.9l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.9-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 0 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.9.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1A1.7 1.7 0 0 0 4.5 15a1.7 1.7 0 0 0-1.5-1H3a2 2 0 0 1 0-4h.1A1.7 1.7 0 0 0 4.6 9a1.7 1.7 0 0 0-.3-1.9l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.9.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 0 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.9-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.9V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 0 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/></svg>;
    case 'rupee':  return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth={sw + 0.2} strokeLinecap="round" strokeLinejoin="round"><path d="M6 5h12M6 9h12M8 5c4 0 6 1.5 6 4s-2 4-6 4h-2l8 8"/></svg>;
    case 'badge':  return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2 4 6v6c0 4.5 3.4 8.6 8 9.7 4.6-1.1 8-5.2 8-9.7V6l-8-4z"/><path d="m8 12 3 3 5-6" stroke="#fff" strokeWidth="1.8" fill="none" strokeLinecap="round" strokeLinejoin="round"/></svg>;
    case 'pulse':  return <svg {...common}><path d="M3 12h4l2-7 4 14 2-7h6"/></svg>;
    case 'bell-on': return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M6 8a6 6 0 1 1 12 0c0 5 2 6 2 7H4c0-1 2-2 2-7zM10 20a2 2 0 0 0 4 0"/></svg>;
    case 'repeat': return <svg {...common}><path d="M3 12V8a3 3 0 0 1 3-3h12l-3-3m3 3-3 3M21 12v4a3 3 0 0 1-3 3H6l3 3m-3-3 3-3"/></svg>;
    case 'mail':   return <svg {...common}><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg>;
    case 'lock':   return <svg {...common}><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>;
    case 'user':   return <svg {...common}><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-7 8-7s8 3 8 7"/></svg>;
    case 'key':    return <svg {...common}><circle cx="8" cy="15" r="4"/><path d="m11 12 9-9m-4 4 3 3"/></svg>;
    case 'eye':    return <svg {...common}><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg>;
    case 'eye-off':return <svg {...common}><path d="M3 3l18 18M10.6 6.2A10.5 10.5 0 0 1 12 6c6 0 10 6 10 6a17.5 17.5 0 0 1-3.4 4M6.6 6.6C3.7 8.7 2 12 2 12s4 7 10 7c1.7 0 3.2-.4 4.5-1M9.5 9.5a3 3 0 0 0 4 4"/></svg>;
    case 'sign-out': return <svg {...common}><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M9 12h12"/></svg>;
    case 'moon':   return <svg {...common}><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>;
    case 'globe':  return <svg {...common}><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/></svg>;
    case 'info':   return <svg {...common}><circle cx="12" cy="12" r="9"/><path d="M12 16v-5M12 8.5v.5"/></svg>;
    case 'check':  return <svg {...common}><path d="m5 12 5 5L20 7"/></svg>;
    case 'shield-check': return <svg {...common}><path d="M12 2 4 5v7c0 5 3.5 8.5 8 10 4.5-1.5 8-5 8-10V5l-8-3z"/><path d="m9 12 2 2 4-4"/></svg>;
    case 'faceid': return <svg {...common}><path d="M4 8V6a2 2 0 0 1 2-2h2M16 4h2a2 2 0 0 1 2 2v2M4 16v2a2 2 0 0 0 2 2h2M16 20h2a2 2 0 0 0 2-2v-2"/><path d="M9 9v1M15 9v1M9 14c1 1 2 1.5 3 1.5s2-.5 3-1.5M12 9v4l-1 1"/></svg>;
    case 'finger': return <svg {...common}><path d="M12 11c-2 0-3 1.5-3 3.5S10 18 12 18s3-1.5 3-3.5M12 7c-3 0-5 2-5 5 0 4 1 6 2 8M12 4c-4 0-7 3-7 8M12 4c4 0 7 3 7 8 0 2-.5 3.5-1 5"/></svg>;
    case 'google': return <svg width={size} height={size} viewBox="0 0 24 24"><path fill="#4285F4" d="M23 12.27c0-.85-.07-1.66-.21-2.45H12v4.65h6.18c-.27 1.43-1.07 2.64-2.28 3.45v2.86h3.69C21.74 18.79 23 15.79 23 12.27z"/><path fill="#34A853" d="M12 23c3.08 0 5.66-1.02 7.55-2.77l-3.69-2.86c-1.02.68-2.32 1.09-3.86 1.09-2.97 0-5.49-2-6.39-4.69H1.83v2.95A11 11 0 0 0 12 23z"/><path fill="#FBBC05" d="M5.61 13.77a6.6 6.6 0 0 1 0-4.19V6.63H1.83a11 11 0 0 0 0 9.74l3.78-2.6z"/><path fill="#EA4335" d="M12 6.58c1.68 0 3.18.58 4.36 1.7l3.27-3.27C17.66 3.13 15.08 2 12 2A11 11 0 0 0 1.83 6.63l3.78 2.95C6.51 8.58 9.03 6.58 12 6.58z"/></svg>;
    case 'apple':  return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M16.4 12.7c0-2.7 2.2-4 2.3-4-1.3-1.8-3.2-2.1-3.9-2.1-1.7-.2-3.3.9-4.1.9-.9 0-2.2-.9-3.6-.9-1.8 0-3.5 1.1-4.5 2.7-1.9 3.3-.5 8.2 1.4 10.9.9 1.3 2 2.8 3.4 2.8 1.3 0 1.9-.9 3.5-.9s2 .9 3.5.9c1.4 0 2.4-1.3 3.3-2.7 1-1.5 1.5-3 1.5-3.1-.1 0-2.8-1.1-2.8-4.5zM14 5c.8-.9 1.3-2.1 1.1-3.4-1.1.1-2.4.7-3.1 1.6-.7.8-1.3 2.1-1.1 3.3 1.2.1 2.4-.6 3.1-1.5z"/></svg>;
    case 'sliders': return <svg {...common}><path d="M4 6h12M20 6h0M4 12h6M14 12h6M4 18h10M18 18h2"/><circle cx="18" cy="6" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="16" cy="18" r="2"/></svg>;
    case 'logout': return <svg {...common}><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M9 12h12"/></svg>;
    case 'whatsapp': return <svg width={size} height={size} viewBox="0 0 24 24" fill={color}><path d="M12 2C6.5 2 2 6.5 2 12c0 1.9.5 3.6 1.4 5.1L2 22l5.1-1.3c1.4.8 3.1 1.2 4.9 1.2 5.5 0 10-4.5 10-10S17.5 2 12 2zm5.5 14.2c-.2.6-1.2 1.2-1.7 1.3-.4.1-1 .1-1.6-.1l-1.5-.6c-2.6-1.1-4.3-3.8-4.4-4-.1-.2-1.1-1.5-1.1-2.8 0-1.3.7-2 1-2.3.3-.3.6-.4.8-.4h.6c.2 0 .5 0 .7.5l1 2.4c.1.2.1.4 0 .6l-.4.5c-.1.1-.3.3-.1.6.2.3.7 1.2 1.6 2 1.1.9 2 1.3 2.3 1.4.3.1.4.1.6-.1l.7-.9c.2-.3.4-.2.7-.1l2.2 1c.3.1.5.2.6.4 0 .2 0 1-.2 1.6z"/></svg>;
    default: return null;
  }
}

Object.assign(window, {
  DB_COLORS, DB_FONT, DBLogo, AppHeader, CenteredHeader, Avatar,
  DayPill, CategoryChip, IconBubble, SearchBar, ScreenBg,
  ImgPlaceholder, Icon, REMINDER_TYPES,
});
