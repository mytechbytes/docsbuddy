import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/db_logo.dart';
import '../../auth/application/auth_providers.dart';
import '../application/security_providers.dart';
import 'lock_screen.dart';

/// Wraps the whole app (`MaterialApp.builder`) so the lock covers **every**
/// screen — including ones pushed on top of the tabs — and not just the home
/// screen it used to live in, which left an asset page readable after the lock
/// had engaged.
///
/// While locked the app underneath is kept alive but hidden (not painted, not
/// focusable, invisible to screen readers), so a form half-filled before the
/// phone was put down is still there after unlocking. It also forwards
/// lifecycle events to [AppLockController], and covers the app with a plain
/// logo screen whenever the app isn't in the foreground, so the app switcher
/// never shows a snapshot of someone's documents.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  /// The app is not in the foreground (inactive, e.g. in the app switcher).
  bool _away = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appLockProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        lock.appPaused();
      case AppLifecycleState.resumed:
        lock.appResumed();
      default:
        break;
    }
    final away = state != AppLifecycleState.resumed;
    if (away != _away) setState(() => _away = away);
  }

  @override
  Widget build(BuildContext context) {
    // Nothing to protect until someone is signed in.
    final signedIn = ref.watch(authStateProvider).value ?? ref.watch(authRepositoryProvider).isSignedIn;
    final lockOn = ref.watch(securityPrefsProvider.select((p) => p.appLock));
    final locked = ref.watch(appLockProvider) && signedIn;
    final cover = !locked && _away && lockOn && signedIn;

    // A keyboard left up over the lock screen would still be typing into the
    // hidden form.
    ref.listen(appLockProvider, (_, nowLocked) {
      if (nowLocked) FocusManager.instance.primaryFocus?.unfocus();
    });

    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(
          offstage: locked,
          child: TickerMode(enabled: !locked, child: widget.child),
        ),
        if (locked) const LockScreen() else if (cover) const _PrivacyCover(key: privacyCoverKey),
      ],
    );
  }
}

/// Identifies the privacy cover (for tests and for anything that needs to know
/// whether the app is currently hidden from the app switcher).
const privacyCoverKey = Key('app-lock-privacy-cover');

/// What the app switcher shows instead of the app.
class _PrivacyCover extends StatelessWidget {
  const _PrivacyCover({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: context.palette.background,
        child: const Center(child: DbLogo(size: 26)),
      );
}
