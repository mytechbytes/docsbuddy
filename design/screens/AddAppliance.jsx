// ADD APPLIANCE — bill / asset entry form
function AddAppliance() {
  return (
    <ScreenBg>
      <div style={{ display: 'flex', justifyContent: 'space-between', padding: '14px 22px 6px' }}>
        <Icon name="back" size={22}/>
        <Icon name="close" size={22}/>
      </div>
      <div style={{ padding: '10px 22px 14px', fontWeight: 800, fontSize: 22, letterSpacing: '-0.01em' }}>
        Select Your Appliances
      </div>

      <div style={{ padding: '0 22px', display: 'flex', flexDirection: 'column', gap: 14 }}>
        <Field label="Appliance Name" required>
          <InputBox icon="search" placeholder="Search Your Appliance" />
        </Field>
        <Field label="Appliance Type">
          <InputBox placeholder="Search Your Appliance" trailing="caret" />
        </Field>
        <Field label="Brand Name">
          <InputBox placeholder="Brand Name" />
        </Field>
        <Field label="Model Number">
          <InputBox placeholder="Model Number" />
        </Field>
        <Field label="Purchase Date" required>
          <InputBox placeholder="DD/MM/YY" trailingIcon />
        </Field>
        <Field label="AMC Date" required>
          <InputBox placeholder="DD/MM/YY" trailingIcon />
        </Field>
        <div>
          <Label text="Add Invoice" required />
          <div style={{ display: 'flex', gap: 12, marginTop: 6 }}>
            <ActionTile icon="cal-plus" />
            <ActionTile icon="cam" />
          </div>
        </div>
      </div>

      <div style={{ display: 'flex', gap: 12, padding: '24px 22px 10px' }}>
        <button style={btnGhost}>Cancel</button>
        <button style={btnPrimary}>Save</button>
      </div>
    </ScreenBg>
  );
}

function Label({ text, required }) {
  return (
    <div style={{ fontWeight: 700, fontSize: 14, color: DB_COLORS.ink, marginBottom: 6 }}>
      {text}{required && <span style={{ color: '#d24b54' }}>*</span>}
    </div>
  );
}

function Field({ label, required, children }) {
  return (
    <div>
      <Label text={label} required={required} />
      {children}
    </div>
  );
}

function InputBox({ placeholder, icon, trailing, trailingIcon }) {
  return (
    <div style={{
      height: 48, background: '#fff', borderRadius: 12,
      display: 'flex', alignItems: 'center', gap: 10, padding: '0 14px',
      border: '1px solid #e6ebf3', boxShadow: '0 1px 2px rgba(15,30,55,0.03)',
    }}>
      {icon && <Icon name={icon} size={16} color="#94a0b3" />}
      <div style={{ flex: 1, fontSize: 14, color: '#a3acba' }}>{placeholder}</div>
      {trailing === 'caret' && <Icon name="caret" size={16} color="#94a0b3" />}
      {trailingIcon && (
        <div style={{ width: 38, height: 38, marginRight: -8, background: '#fff', borderRadius: 10,
          border: '1px solid #e6ebf3', display: 'grid', placeItems: 'center', boxShadow: '0 1px 2px rgba(15,30,55,0.04)' }}>
          <Icon name="cal" size={18} color="#324159" />
        </div>
      )}
    </div>
  );
}

function ActionTile({ icon }) {
  return (
    <div style={{
      flex: 1, height: 56, background: '#fff', borderRadius: 12,
      display: 'grid', placeItems: 'center',
      border: '1px solid #e6ebf3', boxShadow: '0 1px 2px rgba(15,30,55,0.03)',
    }}>
      <Icon name={icon} size={22} color="#0d1a2b" />
    </div>
  );
}

const btnGhost = {
  flex: 1, height: 50, borderRadius: 12, border: '1.5px solid #cfd6e2',
  background: 'transparent', color: DB_COLORS.ink, fontFamily: DB_FONT,
  fontWeight: 700, fontSize: 15,
};
const btnPrimary = {
  flex: 1, height: 50, borderRadius: 12, border: 'none',
  background: '#0d1a2b', color: '#fff', fontFamily: DB_FONT,
  fontWeight: 700, fontSize: 15,
};

Object.assign(window, { AddAppliance });
