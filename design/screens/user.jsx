// ─── USER & SETTINGS SCREENS ─────────────────────────────────

// ─── PROFILE ─────────────────────────────────────────────────
function Profile() {
  return (
    <ScreenBg>
      <CenteredHeader back title="Profile" bell={false} avatar={false} />

      {/* Avatar block */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '10px 22px 4px' }}>
        <div style={{ position: 'relative' }}>
          <div style={{
            width: 96, height: 96, borderRadius: 999, overflow: 'hidden',
            background: 'linear-gradient(135deg, #f1c27d 0%, #d68b5c 60%, #5e4b3a 100%)',
            border: '3px solid #fff', boxShadow: '0 4px 14px rgba(15,30,55,0.12)',
            position: 'relative',
          }}>
            <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 50% 35%, rgba(255,255,255,0.45), transparent 35%)' }}/>
          </div>
          <div style={{
            position: 'absolute', bottom: 0, right: 0, width: 30, height: 30, borderRadius: 999,
            background: DB_COLORS.ink, display: 'grid', placeItems: 'center',
            border: '2px solid #fff',
          }}>
            <Icon name="cam" size={14} color="#fff" />
          </div>
        </div>
        <div style={{ fontWeight: 800, fontSize: 19, marginTop: 14, letterSpacing: '-0.01em' }}>Anand Kumar</div>
        <div style={{ fontSize: 13, color: DB_COLORS.muted, marginTop: 2 }}>anand@kumar.dev</div>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, padding: '4px 12px', marginTop: 8,
          background: '#e3f5e7', color: DB_COLORS.green, borderRadius: 999, fontSize: 11, fontWeight: 700 }}>
          <Icon name="shield-check" size={12} color={DB_COLORS.green} /> Verified
        </div>
      </div>

      {/* Stats */}
      <div style={{ margin: '18px 18px 0', background: '#fff', borderRadius: 16, padding: '14px 0',
        border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)',
        display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)' }}>
        {[
          { v: 23, k: 'Assets' },
          { v: 14, k: 'Reminders' },
          { v: 47, k: 'Documents' },
        ].map((s, i) => (
          <div key={i} style={{
            textAlign: 'center', padding: '4px 6px',
            borderLeft: i > 0 ? '1px solid #eef2f8' : 'none',
          }}>
            <div style={{ fontWeight: 800, fontSize: 22, color: DB_COLORS.ink, letterSpacing: '-0.02em' }}>{s.v}</div>
            <div style={{ fontSize: 11, color: DB_COLORS.muted, marginTop: 2 }}>{s.k}</div>
          </div>
        ))}
      </div>

      {/* Family card */}
      <div style={{ margin: '14px 18px 0', background: '#fff', borderRadius: 16, padding: '14px 16px',
        border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
          <div>
            <div style={{ fontWeight: 800, fontSize: 15, color: DB_COLORS.ink }}>Kumar Family</div>
            <div style={{ fontSize: 11, color: DB_COLORS.muted }}>4 members · You&rsquo;re the owner</div>
          </div>
          <div style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '6px 10px',
            background: '#eef3fb', color: DB_COLORS.chipBlue, borderRadius: 999, fontSize: 11, fontWeight: 700 }}>
            <Icon name="plus" size={11} color={DB_COLORS.chipBlue}/> Invite
          </div>
        </div>
        <div style={{ display: 'flex', gap: -8 }}>
          {[0,1,2,3].map(i => (
            <div key={i} style={{ marginLeft: i === 0 ? 0 : -8 }}>
              <Avatar size={32} />
            </div>
          ))}
          <div style={{ marginLeft: -8, width: 32, height: 32, borderRadius: 999, background: '#eef3fb',
            display: 'grid', placeItems: 'center', border: '1.5px solid #fff', fontSize: 11, fontWeight: 700, color: DB_COLORS.ink2 }}>
            +1
          </div>
        </div>
      </div>

      {/* Action rows */}
      <div style={{ margin: '14px 18px 0', background: '#fff', borderRadius: 16,
        border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)', overflow: 'hidden' }}>
        <SettingRow icon="user" label="Edit personal info" />
        <SettingRow icon="bell" label="Notification preferences" />
        <SettingRow icon="sliders" label="App settings" />
        <SettingRow icon="logout" label="Sign out" danger last />
      </div>
    </ScreenBg>
  );
}

// ─── SETTINGS ────────────────────────────────────────────────
function Settings() {
  return (
    <ScreenBg>
      <CenteredHeader back title="Settings" bell={false} avatar={false} />

      <SettingsGroup title="ACCOUNT">
        <SettingRow icon="user"  label="Personal information" />
        <SettingRow icon="mail"  label="Email" value="anand@kumar.dev" />
        <SettingRow icon="key"   label="Change password" />
        <SettingRow icon="shield-check" label="Security & 2FA" value="On" last />
      </SettingsGroup>

      <SettingsGroup title="NOTIFICATIONS">
        <SettingRow icon="bell"  label="Push notifications" toggle value={true} />
        <SettingRow icon="mail"  label="Email reminders"     toggle value={false} />
        <SettingRow icon="whatsapp" label="WhatsApp reminders" toggle value={false} />
        <SettingRow icon="repeat" label="Default offsets" value="30 · 7 · 1d" last />
      </SettingsGroup>

      <SettingsGroup title="FAMILY">
        <SettingRow icon="user"  label="Manage Kumar Family" value="4 members" />
        <SettingRow icon="plus"  label="Invite a member" last />
      </SettingsGroup>

      <SettingsGroup title="PREFERENCES">
        <SettingRow icon="globe" label="Language" value="English" />
        <SettingRow icon="moon"  label="Appearance" value="System" />
        <SettingRow icon="cal"   label="Date format" value="DD/MM/YY" last />
      </SettingsGroup>

      <SettingsGroup title="ABOUT">
        <SettingRow icon="info"  label="Help & support" />
        <SettingRow icon="doc"   label="Privacy policy" />
        <SettingRow icon="doc"   label="Terms of service" last />
      </SettingsGroup>

      <div style={{ padding: '14px 18px 24px', textAlign: 'center', fontSize: 11, color: DB_COLORS.muted }}>
        DocsBuddy v1.0.4 (build 218)
      </div>
    </ScreenBg>
  );
}

function SettingsGroup({ title, children }) {
  return (
    <div style={{ marginTop: 18 }}>
      <div style={{ padding: '0 22px 6px', fontSize: 11, fontWeight: 700, color: DB_COLORS.muted, letterSpacing: '0.1em' }}>{title}</div>
      <div style={{ margin: '0 18px', background: '#fff', borderRadius: 14,
        border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)', overflow: 'hidden' }}>
        {children}
      </div>
    </div>
  );
}

function SettingRow({ icon, label, value, toggle, danger, last }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 14, padding: '14px 16px',
      borderBottom: last ? 'none' : '1px solid #f0f3f8',
    }}>
      <div style={{ width: 32, height: 32, borderRadius: 8,
        background: danger ? '#fdebec' : '#eef3fb', display: 'grid', placeItems: 'center' }}>
        <Icon name={icon} size={16} color={danger ? '#d24b54' : DB_COLORS.ink} />
      </div>
      <div style={{ flex: 1, minWidth: 0, fontSize: 14, fontWeight: 600,
        color: danger ? '#d24b54' : DB_COLORS.ink }}>{label}</div>
      {value !== undefined && !toggle && (
        <div style={{ fontSize: 12, color: DB_COLORS.muted, fontWeight: 600 }}>{value}</div>
      )}
      {toggle && <Toggle on={value} />}
      {!toggle && !danger && <Icon name="chevron-right" size={16} color="#94a0b3" />}
    </div>
  );
}

function Toggle({ on }) {
  return (
    <div style={{
      width: 42, height: 24, borderRadius: 999,
      background: on ? DB_COLORS.green : '#cfd6e2',
      display: 'flex', alignItems: 'center',
      padding: 2, justifyContent: on ? 'flex-end' : 'flex-start',
      transition: 'background 0.2s',
    }}>
      <div style={{ width: 20, height: 20, borderRadius: 999, background: '#fff',
        boxShadow: '0 1px 3px rgba(0,0,0,0.2)' }}/>
    </div>
  );
}

// ─── CHANGE PASSWORD ─────────────────────────────────────────
function ChangePassword() {
  return (
    <ScreenBg>
      <CenteredHeader back title="Change Password" bell={false} avatar={false} />

      <div style={{ padding: '14px 22px 4px' }}>
        <div style={{ fontSize: 13, color: DB_COLORS.muted, lineHeight: 1.5 }}>
          For your security, you'll be signed out of other devices after changing your password.
        </div>
      </div>

      <div style={{ padding: '20px 22px 0' }}>
        <AuthField label="Current Password" icon="lock" value="••••••••" password eye="off" />
        <AuthField label="New Password"     icon="lock" value="••••••••••••" password eye="off" />

        {/* Strength */}
        <div style={{ display: 'flex', gap: 4, margin: '-4px 0 6px' }}>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
          <div style={{ flex: 1, height: 4, borderRadius: 999, background: DB_COLORS.green }}/>
        </div>
        <div style={{ fontSize: 11, color: DB_COLORS.green, fontWeight: 700, marginBottom: 14 }}>Excellent</div>

        <AuthField label="Confirm New Password" icon="lock" value="••••••••••••" password eye="off" />

        <div style={{ height: 8 }}/>
        <PrimaryBtn label="Update Password" />
        <div style={{ height: 10 }}/>
        <GhostBtn label="Cancel" />
      </div>
    </ScreenBg>
  );
}

// ─── SECURITY & 2FA ──────────────────────────────────────────
function Security() {
  return (
    <ScreenBg>
      <CenteredHeader back title="Security" bell={false} avatar={false} />

      {/* Biometric */}
      <SettingsGroup title="BIOMETRIC LOGIN">
        <SettingRow icon="faceid" label="Face ID"      toggle value={true} />
        <SettingRow icon="finger" label="Fingerprint"  toggle value={false} last />
      </SettingsGroup>

      {/* 2FA */}
      <div style={{ padding: '18px 22px 6px', fontSize: 11, fontWeight: 700, color: DB_COLORS.muted, letterSpacing: '0.1em' }}>TWO-FACTOR AUTHENTICATION</div>
      <div style={{ margin: '0 18px', background: '#fff', borderRadius: 14,
        border: '1px solid #eef2f8', boxShadow: '0 1px 4px rgba(15,30,55,0.04)', overflow: 'hidden' }}>
        <div style={{ padding: '14px 16px', borderBottom: '1px solid #f0f3f8',
          display: 'flex', alignItems: 'center', gap: 14 }}>
          <div style={{ width: 36, height: 36, borderRadius: 10, background: '#e3f5e7',
            display: 'grid', placeItems: 'center' }}>
            <Icon name="shield-check" size={18} color={DB_COLORS.green} />
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontWeight: 700, fontSize: 14, color: DB_COLORS.ink }}>2FA is enabled</div>
            <div style={{ fontSize: 11, color: DB_COLORS.muted }}>Authenticator app · Last used 2h ago</div>
          </div>
          <Toggle on={true} />
        </div>

        <div style={{ padding: '14px 16px', borderBottom: '1px solid #f0f3f8' }}>
          <div style={{ fontWeight: 700, fontSize: 13, color: DB_COLORS.ink, marginBottom: 4 }}>Authenticator app</div>
          <div style={{ fontSize: 11, color: DB_COLORS.muted, marginBottom: 10 }}>Use Google Authenticator, Authy, 1Password, etc.</div>

          {/* QR placeholder */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{
              width: 84, height: 84, background: '#fff', border: '1px solid #e6ebf3', borderRadius: 8,
              backgroundImage: `
                linear-gradient(90deg, #0d1a2b 8px, transparent 0),
                linear-gradient(90deg, transparent 14px, #0d1a2b 14px, #0d1a2b 22px, transparent 0),
                linear-gradient(90deg, transparent 28px, #0d1a2b 28px, #0d1a2b 40px, transparent 0),
                linear-gradient(180deg, #0d1a2b 6px, transparent 0),
                linear-gradient(180deg, transparent 14px, #0d1a2b 14px, #0d1a2b 20px, transparent 0),
                linear-gradient(180deg, transparent 30px, #0d1a2b 30px, #0d1a2b 40px, transparent 0)`,
              backgroundSize: '46px 46px, 46px 46px, 46px 46px, 46px 46px, 46px 46px, 46px 46px',
              backgroundPosition: 'left top, left top, left top, left top, left top, left top',
              padding: 6,
            }}>
              <div style={{ width: '100%', height: '100%', background: `
                radial-gradient(circle, #0d1a2b 1.2px, transparent 1.4px) 0 0/8px 8px,
                linear-gradient(#fff, #fff)`,
                backgroundBlendMode: 'normal' }}/>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 11, color: DB_COLORS.ink, letterSpacing: '0.05em', wordBreak: 'break-all' }}>
                JBSWY3DPEHPK3PXP
              </div>
              <div style={{ fontSize: 11, color: DB_COLORS.chipBlue, fontWeight: 700, marginTop: 6 }}>Copy key</div>
            </div>
          </div>
        </div>

        <div style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14 }}>
          <div style={{ width: 32, height: 32, borderRadius: 8, background: '#eef3fb', display: 'grid', placeItems: 'center' }}>
            <Icon name="key" size={16} color={DB_COLORS.ink} />
          </div>
          <div style={{ flex: 1, fontSize: 14, fontWeight: 600, color: DB_COLORS.ink }}>Recovery codes</div>
          <div style={{ fontSize: 12, color: DB_COLORS.muted }}>10 unused</div>
          <Icon name="chevron-right" size={16} color="#94a0b3" />
        </div>
      </div>

      {/* App lock + sessions */}
      <SettingsGroup title="MORE">
        <SettingRow icon="lock" label="App lock" toggle value={true} />
        <SettingRow icon="cal"  label="Auto-lock after" value="1 min" />
        <SettingRow icon="user" label="Active sessions" value="2 devices" last />
      </SettingsGroup>

      <div style={{ height: 24 }}/>
    </ScreenBg>
  );
}

Object.assign(window, {
  Profile, Settings, SettingsGroup, SettingRow, Toggle,
  ChangePassword, Security,
});
