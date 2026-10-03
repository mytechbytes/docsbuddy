import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/db_logo.dart';
import '../../auth/application/auth_controller.dart';
import '../application/security_providers.dart';
import '../domain/security_models.dart';
import 'security_names.dart';

/// Full-screen gate shown while the app is locked: the fingerprint / Face ID
/// quick-unlock surface (design screens 09/17).
///
/// It prompts as soon as it appears and again on tap, tells the person what
/// happened when the prompt didn't unlock (not recognised, too many attempts),
/// and always offers a way out: signing out, or — when the device no longer has
/// any screen lock — turning the lock off. A lock with no exit would strand
/// someone whose sensor stops working.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _busy = false;
  bool _signOutFailed = false;
  BiometricResult? _last;

  @override
  void initState() {
    super.initState();
    // Prompt immediately on lock.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _signOutFailed = false;
    });
    final result = await ref.read(appLockProvider.notifier).unlock();
    // On success the gate removes this screen, so there is nothing to update.
    if (mounted) {
      setState(() {
        _busy = false;
        _last = result;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    final ok = await ref.read(authControllerProvider.notifier).signOut();
    if (mounted) {
      setState(() {
        _busy = false;
        _signOutFailed = !ok;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kinds = ref.watch(biometricKindsProvider).value ?? const <BiometricKind>[];
    final unavailable = _last == BiometricResult.unavailable;
    final message = _signOutFailed
        ? context.l10n.lockError
        : unavailable
            ? context.l10n.lockUnavailableBody
            : _last?.message(context);

    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DbLogo(size: 26),
                const SizedBox(height: 10),
                Text(context.l10n.lockLocked,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.palette.textMuted)),
                const SizedBox(height: 32),
                Semantics(
                  button: true,
                  label: context.l10n.lockTapToUnlock,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _unlock,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: context.palette.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.palette.border),
                      ),
                      child: _busy
                          ? const Padding(padding: EdgeInsets.all(28), child: CircularProgressIndicator(strokeWidth: 2.4))
                          : Icon(kinds.lockIcon, size: 40, color: context.palette.text),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(context.l10n.lockTapToUnlock, style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  // Announced to screen readers when it appears.
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.5, height: 1.4, color: context.palette.danger, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                if (unavailable) ...[
                  const SizedBox(height: 20),
                  GhostButton(
                    label: context.l10n.lockTurnOff,
                    onPressed: () => ref.read(appLockProvider.notifier).turnOffAppLock(),
                  ),
                ],
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _busy ? null : _signOut,
                  child: Text(context.l10n.commonSignOut,
                      style: TextStyle(color: context.palette.textMuted, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
