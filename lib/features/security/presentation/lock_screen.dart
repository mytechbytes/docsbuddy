import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/db_logo.dart';
import '../application/security_providers.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

/// Full-screen gate shown while the app is locked — the biometric
/// quick-unlock surface (design screens 09/17).
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Prompt immediately on lock.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_busy) return;
    setState(() => _busy = true);
    await ref.read(appLockProvider.notifier).unlock();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DbLogo(size: 26),
              const SizedBox(height: 10),
              Text(context.l10n.lockLocked, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.palette.textMuted)),
              const SizedBox(height: 32),
              InkWell(
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
                      : Icon(Icons.fingerprint, size: 40, color: context.palette.text),
                ),
              ),
              const SizedBox(height: 14),
              Text(context.l10n.lockTapToUnlock, style: TextStyle(fontSize: 13, color: context.palette.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
