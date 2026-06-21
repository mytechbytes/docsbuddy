// ─── AUTH ATOMS ─────────────────────────────────────────────────
function AuthField({ label, icon, placeholder, value, password, eye, trailing, error }) {
  return (
    <div style={{ marginBottom: 14 }}>
      {label && <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, marginBottom: 6 }}>{label}</div>}
      <div style={{
        height: 52, background: '#fff', borderRadius: 12, display: 'flex',
        alignItems: 'center', padding: '0 14px', gap: 10,
        border: `1.5px solid ${error ? '#d24b54' : '#e6ebf3'}`,
        boxShadow: '0 1px 2px rgba(15,30,55,0.03)',
      }}>
        {icon && <Icon name={icon} size={18} color="#6b7891" />}
        <div style={{ flex: 1, fontSize: 14, color: value ? DB_COLORS.ink : '#a3acba', fontWeight: value ? 600 : 400, letterSpacing: password && value ? 4 : 0 }}>
          {value || placeholder}
        </div>
        {eye && <Icon name={eye === 'on' ? 'eye' : 'eye-off'} size={18} color="#94a0b3" />}
        {trailing}
      </div>
      {error && <div style={{ fontSize: 11, color: '#d24b54', marginTop: 4 }}>{error}</div>}
    </div>
  );
}

function PrimaryBtn({ label, dark = true, full = true, disabled = false }) {
  return (
    <button style={{
      width: full ? '100%' : 'auto',
      height: 52, borderRadius: 12, border: 'none',
      background: disabled ? '#cfd6e2' : (dark ? '#0d1a2b' : DB_COLORS.chipBlue),
      color: '#fff', fontFamily: DB_FONT, fontWeight: 700, fontSize: 15,
      letterSpacing: '0.01em',
    }}>{label}</button>
  );
}

function GhostBtn({ label, full = true }) {
  return (
    <button style={{
      width: full ? '100%' : 'auto',
      height: 52, borderRadius: 12, border: '1.5px solid #cfd6e2',
      background: 'transparent', color: DB_COLORS.ink, fontFamily: DB_FONT,
      fontWeight: 700, fontSize: 15,
    }}>{label}</button>
  );
}

function SocialBtn({ provider }) {
  const cfg = {
    google: { icon: 'google', label: 'Continue with Google' },
    apple:  { icon: 'apple',  label: 'Continue with Apple' },
  }[provider];
  return (
    <button style={{
      width: '100%', height: 50, borderRadius: 12,
      border: '1.5px solid #e1e6ef', background: '#fff',
      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
      fontFamily: DB_FONT, fontWeight: 700, fontSize: 14, color: DB_COLORS.ink,
    }}>
      <Icon name={cfg.icon} size={20} color={provider === 'apple' ? '#000' : undefined} />
      {cfg.label}
    </button>
  );
}

function OrDivider({ label = 'or continue with' }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '22px 0 18px' }}>
      <div style={{ flex: 1, height: 1, background: '#e1e6ef' }}/>
      <div style={{ fontSize: 11, color: DB_COLORS.muted, textTransform: 'uppercase', letterSpacing: '0.1em' }}>{label}</div>
      <div style={{ flex: 1, height: 1, background: '#e1e6ef' }}/>
    </div>
  );
}

function AuthHero({ title, subtitle, big }) {
  return (
    <div style={{ padding: '24px 24px 18px' }}>
      <div style={{ fontWeight: 800, fontSize: big ? 30 : 26, letterSpacing: '-0.02em', color: DB_COLORS.ink, lineHeight: 1.1 }}>{title}</div>
      {subtitle && <div style={{ fontSize: 14, color: DB_COLORS.muted, marginTop: 8, maxWidth: 320 }}>{subtitle}</div>}
    </div>
  );
}

// ─── SIGN IN ─────────────────────────────────────────────────
function SignIn() {
  return (
    <ScreenBg>
      <div style={{ padding: '24px 24px 0', display: 'flex', justifyContent: 'center' }}>
        <DBLogo size={26} />
      </div>

      <AuthHero title="Welcome back" subtitle="Sign in to keep your assets and reminders in sync." big />

      <div style={{ padding: '0 24px' }}>
        <AuthField label="Email" icon="mail" value="anand@kumar.dev" />
        <AuthField label="Password" icon="lock" placeholder="••••••••" value="••••••••" password eye="off" />

        <div style={{ textAlign: 'right', marginTop: -4, marginBottom: 18, fontSize: 13, fontWeight: 700, color: DB_COLORS.chipBlue }}>
          Forgot password?
        </div>

        <div style={{ display: 'flex', gap: 10 }}>
          <div style={{ flex: 1 }}><PrimaryBtn label="Sign In" /></div>
          <button style={{
            width: 52, height: 52, borderRadius: 12, border: 'none', background: '#0d1a2b',
            display: 'grid', placeItems: 'center',
          }}>
            <Icon name="faceid" size={22} color="#fff" />
          </button>
        </div>

        <OrDivider />
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <SocialBtn provider="google" />
          <SocialBtn provider="apple" />
        </div>
      </div>

      <div style={{ textAlign: 'center', marginTop: 22, fontSize: 13, color: DB_COLORS.ink2 }}>
        Don&rsquo;t have an account? <span style={{ color: DB_COLORS.chipBlue, fontWeight: 700 }}>Sign up</span>
      </div>
    </ScreenBg>
  );
}

// ─── SIGN UP ─────────────────────────────────────────────────
function SignUp() {
  return (
    <ScreenBg>
      <div style={{ display: 'flex', justifyContent: 'space-between', padding: '14px 22px 0' }}>
        <Icon name="back" size={22}/>
        <DBLogo size={18}/>
        <div style={{ width: 22 }}/>
      </div>

      <AuthHero title="Create your account" subtitle="Track warranties, bills and renewals with your family — never miss a due date." />

      <div style={{ padding: '0 24px' }}>
        <AuthField label="Full Name" icon="user" value="Anand Kumar" />
        <AuthField label="Email" icon="mail" placeholder="you@example.com" value="anand@kumar.dev" />
        <AuthField label="Password" icon="lock" value="••••••••••" password eye="off" />

        {/* Strength bar */}
        <div style={{ display: 'flex', gap: 4, margin: '-4px 0 6px' }}>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: '#e1e6ef' }}/>
        </div>
        <div style={{ fontSize: 11, color: DB_COLORS.muted, marginBottom: 14 }}>Strong — keep going for excellent.</div>

        {/* Terms checkbox */}
        <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start', marginBottom: 16 }}>
          <div style={{ width: 20, height: 20, borderRadius: 6, background: DB_COLORS.chipBlue, display: 'grid', placeItems: 'center' }}>
            <Icon name="check" size={14} color="#fff" />
          </div>
          <div style={{ fontSize: 12, color: DB_COLORS.ink2, lineHeight: 1.45 }}>
            I agree to the <span style={{ color: DB_COLORS.chipBlue, fontWeight: 700 }}>Terms of Service</span> and <span style={{ color: DB_COLORS.chipBlue, fontWeight: 700 }}>Privacy Policy</span>.
          </div>
        </div>

        <PrimaryBtn label="Create Account" />

        <OrDivider />
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <SocialBtn provider="google" />
          <SocialBtn provider="apple" />
        </div>
      </div>

      <div style={{ textAlign: 'center', marginTop: 22, fontSize: 13, color: DB_COLORS.ink2 }}>
        Already have an account? <span style={{ color: DB_COLORS.chipBlue, fontWeight: 700 }}>Sign in</span>
      </div>
    </ScreenBg>
  );
}

// ─── FORGOT PASSWORD ─────────────────────────────────────────
function ForgotPassword() {
  return (
    <ScreenBg>
      <div style={{ padding: '14px 22px 0' }}>
        <Icon name="back" size={22}/>
      </div>

      {/* Big lock icon */}
      <div style={{ display: 'flex', justifyContent: 'center', marginTop: 22 }}>
        <div style={{ width: 84, height: 84, borderRadius: 999, background: '#eef3fb',
          display: 'grid', placeItems: 'center' }}>
          <Icon name="key" size={36} color={DB_COLORS.chipBlue} />
        </div>
      </div>

      <AuthHero title="Forgot password?" subtitle="No worries. Enter your email and we'll send you a 6-digit code to reset it." />

      <div style={{ padding: '0 24px' }}>
        <AuthField label="Email" icon="mail" value="anand@kumar.dev" />
        <PrimaryBtn label="Send Verification Code" />

        <div style={{ textAlign: 'center', marginTop: 22, fontSize: 13, color: DB_COLORS.ink2 }}>
          Remember it? <span style={{ color: DB_COLORS.chipBlue, fontWeight: 700 }}>Back to sign in</span>
        </div>
      </div>
    </ScreenBg>
  );
}

// ─── OTP VERIFICATION ────────────────────────────────────────
function Verify() {
  const code = ['4', '8', '2', '6', '', ''];
  return (
    <ScreenBg>
      <div style={{ padding: '14px 22px 0' }}>
        <Icon name="back" size={22}/>
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', marginTop: 22 }}>
        <div style={{ width: 84, height: 84, borderRadius: 999, background: '#e3f5e7',
          display: 'grid', placeItems: 'center' }}>
          <Icon name="mail" size={36} color={DB_COLORS.green} />
        </div>
      </div>

      <AuthHero title="Check your inbox" subtitle="We sent a 6-digit code to anand@kumar.dev. Enter it below to continue." />

      <div style={{ padding: '0 24px', display: 'flex', gap: 8, justifyContent: 'space-between', marginBottom: 22 }}>
        {code.map((c, i) => (
          <div key={i} style={{
            width: 46, height: 56, borderRadius: 12, background: '#fff',
            border: `1.5px solid ${c ? DB_COLORS.ink : (i === 4 ? DB_COLORS.chipBlue : '#e6ebf3')}`,
            boxShadow: i === 4 ? `0 0 0 4px ${DB_COLORS.chipBlue}22` : '0 1px 2px rgba(15,30,55,0.03)',
            display: 'grid', placeItems: 'center',
            fontWeight: 800, fontSize: 22, color: DB_COLORS.ink,
            position: 'relative',
          }}>
            {c}
            {i === 4 && !c && <div style={{ width: 2, height: 24, background: DB_COLORS.chipBlue, animation: 'none' }}/>}
          </div>
        ))}
      </div>

      <div style={{ padding: '0 24px' }}>
        <PrimaryBtn label="Verify" />
        <div style={{ textAlign: 'center', marginTop: 18, fontSize: 13, color: DB_COLORS.muted }}>
          Didn&rsquo;t receive it? <span style={{ color: '#c0c8d4' }}>Resend in <b style={{ color: DB_COLORS.ink }}>00:42</b></span>
        </div>
      </div>
    </ScreenBg>
  );
}

// ─── RESET PASSWORD ──────────────────────────────────────────
function ResetPassword() {
  return (
    <ScreenBg>
      <div style={{ padding: '14px 22px 0' }}>
        <Icon name="back" size={22}/>
      </div>

      <div style={{ display: 'flex', justifyContent: 'center', marginTop: 22 }}>
        <div style={{ width: 84, height: 84, borderRadius: 999, background: '#fdf1e0',
          display: 'grid', placeItems: 'center' }}>
          <Icon name="lock" size={36} color="#c68318" />
        </div>
      </div>

      <AuthHero title="Set a new password" subtitle="Choose a strong password you haven't used here before." />

      <div style={{ padding: '0 24px' }}>
        <AuthField label="New Password" icon="lock" value="••••••••••" password eye="off" />
        <AuthField label="Confirm Password" icon="lock" value="••••••••••" password eye="off" />

        <div style={{ background: '#fff', border: '1px solid #eef2f8', borderRadius: 12, padding: '12px 14px', marginBottom: 18 }}>
          <div style={{ fontWeight: 700, fontSize: 12, color: DB_COLORS.ink, marginBottom: 8 }}>Password must have</div>
          {[
            { ok: true,  t: 'At least 8 characters' },
            { ok: true,  t: 'One uppercase letter' },
            { ok: true,  t: 'One number' },
            { ok: false, t: 'One special character (!@#$…)' },
          ].map((r,i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '3px 0' }}>
              <div style={{
                width: 16, height: 16, borderRadius: 999,
                background: r.ok ? DB_COLORS.green : '#e1e6ef',
                display: 'grid', placeItems: 'center',
              }}>
                {r.ok && <Icon name="check" size={11} color="#fff" />}
              </div>
              <span style={{ fontSize: 12, color: r.ok ? DB_COLORS.ink : DB_COLORS.muted }}>{r.t}</span>
            </div>
          ))}
        </div>

        <PrimaryBtn label="Reset Password" />
      </div>
    </ScreenBg>
  );
}

Object.assign(window, {
  AuthField, PrimaryBtn, GhostBtn, SocialBtn, OrDivider, AuthHero,
  SignIn, SignUp, ForgotPassword, Verify, ResetPassword,
});
