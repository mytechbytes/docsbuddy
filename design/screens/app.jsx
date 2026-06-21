// Composes all screens into a design canvas with iOS frames

function ScreenFrame({ children }) {
  return <IOSDevice width={390} height={780}>{children}</IOSDevice>;
}

function App() {
  const onboardingScreens = [
    { id: 'onboarding-1', label: '00a · Welcome',         screen: <Onboarding1 /> },
    { id: 'onboarding-2', label: '00b · Track Assets',    screen: <Onboarding2 /> },
    { id: 'onboarding-3', label: '00c · Smart Reminders', screen: <Onboarding3 /> },
    { id: 'onboarding-4', label: '00d · Family Sharing',  screen: <Onboarding4 /> },
  ];

  const assetScreens = [
    { id: 'dashboard',     label: '01 · Dashboard',         screen: <Dashboard /> },
    { id: 'rooms',         label: '02 · Rooms',             screen: <Rooms /> },
    { id: 'room-detail',   label: '03 · Room Detail',       screen: <RoomDetail /> },
    { id: 'asset-list',    label: '04 · Asset List',        screen: <AssetList /> },
    { id: 'picker',        label: '05 · Appliance Picker',  screen: <AppliancePicker /> },
    { id: 'add',           label: '06 · Add Appliance',     screen: <AddAppliance /> },
    { id: 'asset-detail',  label: '07 · Asset Detail',      screen: <AssetDetail /> },
    { id: 'add-reminder',  label: '08 · Add Reminder',      screen: <AddReminder /> },
  ];

  const authScreens = [
    { id: 'sign-in',  label: '09 · Sign In',          screen: <SignIn /> },
    { id: 'sign-up',  label: '10 · Sign Up',          screen: <SignUp /> },
    { id: 'forgot',   label: '11 · Forgot Password',  screen: <ForgotPassword /> },
    { id: 'verify',   label: '12 · OTP Verification', screen: <Verify /> },
    { id: 'reset',    label: '13 · Reset Password',   screen: <ResetPassword /> },
  ];

  const userScreens = [
    { id: 'profile',  label: '14 · Profile',          screen: <Profile /> },
    { id: 'settings', label: '15 · Settings',         screen: <Settings /> },
    { id: 'change-pw',label: '16 · Change Password',  screen: <ChangePassword /> },
    { id: 'security', label: '17 · Security & 2FA',   screen: <Security /> },
  ];

  const render = (list) => list.map(a => (
    <DCArtboard key={a.id} id={a.id} label={a.label} width={390} height={780}>
      <ScreenFrame>{a.screen}</ScreenFrame>
    </DCArtboard>
  ));

  return (
    <DesignCanvas title="DocsBuddy — Hi-fi Screens" subtitle="iPhone frames @ 390×780 — drag to reorder, double-click an artboard to focus.">
      <DCSection id="onboarding" title="First-launch onboarding" subtitle="Shown only when no session exists on the device — pre-auth walkthrough.">
        {render(onboardingScreens)}
      </DCSection>
      <DCSection id="assets" title="Asset & reminder flow" subtitle="The core product: assets, locations, reminders, documents.">
        {render(assetScreens)}
      </DCSection>
      <DCSection id="auth" title="Authentication" subtitle="Sign in, sign up, password recovery, verification.">
        {render(authScreens)}
      </DCSection>
      <DCSection id="user" title="User & settings" subtitle="Profile, preferences, security, two-factor auth.">
        {render(userScreens)}
      </DCSection>
    </DesignCanvas>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
