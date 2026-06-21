// ─── ONBOARDING WALKTHROUGH (4 slides) ───────────────────────
// Shown only on first launch / when no session exists on this device.

function OnboardingShell({ slideIndex, total = 4, illustration, eyebrow, title, subtitle, primary, secondary, footer }) {
  return (
    <ScreenBg>
      {/* Top row: skip + logo */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '14px 22px 0' }}>
        <DBLogo size={17} />
        {slideIndex < total - 1
          ? <div style={{ fontSize: 13, fontWeight: 700, color: DB_COLORS.muted }}>Skip</div>
          : <div style={{ width: 28 }}/>}
      </div>

      {/* Illustration */}
      <div style={{ padding: '24px 22px 6px', display: 'grid', placeItems: 'center' }}>
        {illustration}
      </div>

      {/* Page indicator */}
      <div style={{ display: 'flex', justifyContent: 'center', gap: 6, margin: '14px 0 18px' }}>
        {[...Array(total)].map((_, i) => (
          <div key={i} style={{
            height: 6, borderRadius: 999, transition: 'all .2s',
            width: i === slideIndex ? 22 : 6,
            background: i === slideIndex ? DB_COLORS.ink : '#d6dce6',
          }}/>
        ))}
      </div>

      {/* Copy */}
      <div style={{ padding: '0 30px', textAlign: 'center' }}>
        {eyebrow && (
          <div style={{ display: 'inline-block', padding: '4px 12px', borderRadius: 999,
            background: '#eef3fb', color: DB_COLORS.chipBlue, fontWeight: 700, fontSize: 11,
            letterSpacing: '0.06em', textTransform: 'uppercase', marginBottom: 10 }}>{eyebrow}</div>
        )}
        <div style={{ fontWeight: 800, fontSize: 26, letterSpacing: '-0.02em', lineHeight: 1.1, color: DB_COLORS.ink }}>{title}</div>
        <div style={{ fontSize: 14, color: DB_COLORS.muted, marginTop: 10, lineHeight: 1.5 }}>{subtitle}</div>
      </div>

      {/* Buttons */}
      <div style={{ padding: '26px 24px 4px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {primary}
        {secondary}
      </div>

      {footer && <div style={{ textAlign: 'center', marginTop: 14, fontSize: 13, color: DB_COLORS.ink2 }}>{footer}</div>}
    </ScreenBg>
  );
}

// Round backdrop common to all illustrations
function IlloStage({ children, tint = '#eef3fb', size = 240 }) {
  return (
    <div style={{
      width: size, height: size, borderRadius: 999, position: 'relative',
      background: `radial-gradient(circle at 50% 40%, ${tint} 0%, ${shadeStage(tint, -6)} 70%, transparent 100%)`,
      display: 'grid', placeItems: 'center',
    }}>
      {children}
    </div>
  );
}
function shadeStage(hex, p) {
  const c = hex.replace('#','');
  const r = parseInt(c.slice(0,2),16), g = parseInt(c.slice(2,4),16), b = parseInt(c.slice(4,6),16);
  const k = (v) => Math.max(0, Math.min(255, v + p));
  return `rgb(${k(r)},${k(g)},${k(b)})`;
}

// ─── Illustration 1 — tilted dashboard collage ───────────────
function IlloWelcome() {
  return (
    <IlloStage tint="#eaf0fb" size={250}>
      {/* faux dashboard card stack, tilted */}
      <div style={{ position: 'relative', width: 230, height: 200 }}>
        {/* navy card behind */}
        <div style={{ position: 'absolute', left: 8, top: 18, width: 150, height: 110, borderRadius: 16,
          background: `linear-gradient(135deg, ${DB_COLORS.cardNavy[0]}, ${DB_COLORS.cardNavy[1]})`,
          transform: 'rotate(-6deg)', boxShadow: '0 10px 24px rgba(15,30,55,0.18)',
          padding: 14, color: '#fff', fontFamily: DB_FONT }}>
          <div style={{ fontSize: 11, fontWeight: 700, opacity: 0.85 }}>Active Invoices</div>
          <div style={{ fontWeight: 800, fontSize: 30, letterSpacing: '-0.02em' }}>23</div>
          <Icon name="doc-fill" size={16} color="#fff" />
        </div>
        {/* teal card front-right */}
        <div style={{ position: 'absolute', right: 0, top: 0, width: 130, height: 100, borderRadius: 16,
          background: `linear-gradient(135deg, ${DB_COLORS.cardTeal[0]}, ${DB_COLORS.cardTeal[1]})`,
          transform: 'rotate(8deg)', boxShadow: '0 12px 26px rgba(15,30,55,0.18)',
          padding: 14, color: '#fff' }}>
          <div style={{ fontSize: 11, fontWeight: 700, opacity: 0.85 }}>Secured</div>
          <div style={{ fontWeight: 800, fontSize: 28, letterSpacing: '-0.02em' }}>14</div>
        </div>
        {/* reminder pill floating */}
        <div style={{ position: 'absolute', left: 20, bottom: 8, background: '#fff', borderRadius: 999,
          padding: '8px 12px', display: 'flex', alignItems: 'center', gap: 8,
          boxShadow: '0 6px 18px rgba(15,30,55,0.14)' }}>
          <IconBubble kind="insurance" size={28} />
          <div>
            <div style={{ fontSize: 11, fontWeight: 700, color: DB_COLORS.ink, lineHeight: 1 }}>Insurance</div>
            <div style={{ fontSize: 9.5, color: DB_COLORS.muted }}>in 25 days</div>
          </div>
          <DayPill days={25} tone="red" small />
        </div>
      </div>
    </IlloStage>
  );
}

// ─── Illustration 2 — variety of assets ──────────────────────
function IlloAssets() {
  const Row = ({ kind, label, sub, tint, off = 0, rot = 0 }) => (
    <div style={{
      position: 'absolute', left: '50%', top: '50%',
      transform: `translate(-50%, calc(-50% + ${off}px)) rotate(${rot}deg)`,
      width: 220, background: '#fff', borderRadius: 14, padding: 10,
      display: 'flex', alignItems: 'center', gap: 10,
      boxShadow: '0 6px 16px rgba(15,30,55,0.12)',
      border: '1px solid #eef2f8',
    }}>
      <ImgPlaceholder label={kind} w={48} h={36} radius={6} tint={tint} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontWeight: 700, fontSize: 12, color: DB_COLORS.ink, lineHeight: 1.2 }}>{label}</div>
        <div style={{ fontSize: 10, color: DB_COLORS.muted }}>{sub}</div>
      </div>
      <CategoryChip label={sub} />
    </div>
  );
  return (
    <IlloStage tint="#e7f4ec" size={250}>
      <div style={{ position: 'relative', width: 240, height: 180 }}>
        <Row kind="kitchen"  label="Samsung 340L Fridge"      sub="Kitchen"    tint="#e8d9c4" off={-66} rot={-4} />
        <Row kind="phone"    label="iPhone 15 Pro"            sub="Smartphone" tint="#dee2ea" off={-12} rot={0} />
        <Row kind="bike"     label="Royal Enfield Classic"    sub="Vehicles"   tint="#dde9e2" off={42}  rot={4} />
      </div>
    </IlloStage>
  );
}

// ─── Illustration 3 — reminders timeline ─────────────────────
function IlloReminders() {
  return (
    <IlloStage tint="#fdebec" size={250}>
      <div style={{ position: 'relative', width: 240, height: 200 }}>
        {/* Center "next due" hero */}
        <div style={{ position: 'absolute', left: '50%', top: 14, transform: 'translateX(-50%)',
          background: '#fff', borderRadius: 14, padding: '12px 14px',
          boxShadow: '0 10px 22px rgba(15,30,55,0.14)',
          display: 'flex', alignItems: 'center', gap: 10, minWidth: 210,
        }}>
          <IconBubble kind="pollution" size={36} />
          <div style={{ flex: 1 }}>
            <div style={{ fontWeight: 700, fontSize: 12, color: DB_COLORS.ink }}>Pollution due</div>
            <div style={{ fontSize: 10, color: DB_COLORS.muted }}>07 Jun · Bike</div>
          </div>
          <DayPill days={15} tone="red" small />
        </div>
        {/* Timeline with markers */}
        <div style={{ position: 'absolute', left: 14, right: 14, top: 96, height: 8, borderRadius: 999,
          background: 'linear-gradient(90deg, #d24b54, #fbd58a 60%, #1ea765)' }}/>
        {[
          { left: '6%',  label: '−30d' },
          { left: '40%', label: '−7d'  },
          { left: '76%', label: '−1d'  },
          { left: '94%', label: 'Due'  },
        ].map((m, i) => (
          <div key={i} style={{ position: 'absolute', left: m.left, top: 86,
            transform: 'translateX(-50%)', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
            <div style={{ width: 12, height: 12, borderRadius: 999, background: '#fff', border: '2px solid #0d1a2b' }}/>
            <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 10, fontWeight: 700, color: DB_COLORS.ink }}>{m.label}</div>
          </div>
        ))}
        {/* Floating bell */}
        <div style={{ position: 'absolute', right: 0, bottom: 0,
          width: 54, height: 54, borderRadius: 999, background: '#0d1a2b',
          display: 'grid', placeItems: 'center', boxShadow: '0 10px 22px rgba(15,30,55,0.3)' }}>
          <Icon name="bell" size={24} color="#fff" />
          <div style={{ position: 'absolute', top: 8, right: 8, width: 12, height: 12, borderRadius: 999,
            background: DB_COLORS.red, border: '2px solid #fff' }}/>
        </div>
      </div>
    </IlloStage>
  );
}

// ─── Illustration 4 — family cluster ─────────────────────────
function IlloFamily() {
  // gradient avatars
  const avs = [
    'linear-gradient(135deg,#f1c27d,#d68b5c)',
    'linear-gradient(135deg,#a8c5e8,#5d80b6)',
    'linear-gradient(135deg,#f4b4c3,#c47093)',
    'linear-gradient(135deg,#bce0c2,#5d9c6b)',
  ];
  return (
    <IlloStage tint="#eef3fb" size={250}>
      <div style={{ position: 'relative', width: 220, height: 200 }}>
        {/* dashed orbit */}
        <div style={{ position: 'absolute', left: '50%', top: '50%',
          width: 180, height: 180, borderRadius: 999,
          transform: 'translate(-50%, -50%)',
          border: '2px dashed rgba(15,30,55,0.18)' }}/>
        {/* center notification card */}
        <div style={{ position: 'absolute', left: '50%', top: '50%',
          transform: 'translate(-50%, -50%)',
          width: 130, background: '#fff', borderRadius: 14, padding: 10,
          boxShadow: '0 10px 22px rgba(15,30,55,0.14)',
          textAlign: 'center' }}>
          <div style={{ width: 32, height: 32, borderRadius: 999, background: '#0d1a2b',
            display: 'grid', placeItems: 'center', margin: '0 auto 6px' }}>
            <Icon name="bell" size={16} color="#fff" />
          </div>
          <div style={{ fontWeight: 700, fontSize: 11, color: DB_COLORS.ink }}>Shared with family</div>
          <div style={{ fontSize: 9.5, color: DB_COLORS.muted, marginTop: 2 }}>Insurance · 25 d</div>
        </div>
        {/* 4 avatars on orbit */}
        {[
          { l: '50%', t: '4%' },  { l: '95%', t: '50%' },
          { l: '50%', t: '95%' }, { l: '4%',  t: '50%' },
        ].map((p, i) => (
          <div key={i} style={{
            position: 'absolute', left: p.l, top: p.t,
            transform: 'translate(-50%, -50%)',
            width: 46, height: 46, borderRadius: 999, background: avs[i],
            border: '3px solid #fff', boxShadow: '0 4px 10px rgba(15,30,55,0.18)',
          }}/>
        ))}
      </div>
    </IlloStage>
  );
}

// ─── Slides ─────────────────────────────────────────────────
function Onboarding1() {
  return (
    <OnboardingShell
      slideIndex={0}
      illustration={<IlloWelcome />}
      eyebrow="Welcome"
      title="Never miss a renewal again"
      subtitle="DocsBuddy keeps track of warranties, insurance, bills and dates — so the deadlines don't sneak up on you."
      primary={<PrimaryBtn label="Get Started" />}
      footer={<span>Already with us? <b style={{ color: DB_COLORS.chipBlue }}>Sign in</b></span>}
    />
  );
}

function Onboarding2() {
  return (
    <OnboardingShell
      slideIndex={1}
      illustration={<IlloAssets />}
      eyebrow="Organise"
      title="All your assets in one place"
      subtitle="Vehicles, appliances, electronics, even documents — organised by room and category."
      primary={<PrimaryBtn label="Next" />}
    />
  );
}

function Onboarding3() {
  return (
    <OnboardingShell
      slideIndex={2}
      illustration={<IlloReminders />}
      eyebrow="Stay ahead"
      title="Smart reminders, weeks ahead"
      subtitle="Configure 60 / 30 / 7 / 1-day alerts. Push, email or WhatsApp — your choice."
      primary={<PrimaryBtn label="Next" />}
    />
  );
}

function Onboarding4() {
  return (
    <OnboardingShell
      slideIndex={3}
      illustration={<IlloFamily />}
      eyebrow="Together"
      title="Keep the whole family in sync"
      subtitle="Invite up to 8 members. Everyone gets reminded, anyone can update — no more single point of failure."
      primary={<PrimaryBtn label="Create Account" />}
      secondary={<GhostBtn label="I already have an account" />}
    />
  );
}

Object.assign(window, {
  OnboardingShell, IlloStage,
  IlloWelcome, IlloAssets, IlloReminders, IlloFamily,
  Onboarding1, Onboarding2, Onboarding3, Onboarding4,
});
