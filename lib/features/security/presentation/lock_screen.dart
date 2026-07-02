import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/db_logo.dart';
import '../application/security_providers.dart';

/// Full-screen gate shown while the app is locked — the biometric
/// quick-unlock surface (design screens 09/17).
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key, required this.onUnlocked});
  final VoidCallback onUnlocked;

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
    final ok = await ref.read(biometricServiceProvider).authenticate('Unlock DocsBuddy');
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DbLogo(size: 26),
              const SizedBox(height: 10),
              const Text('Locked', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.muted)),
              const SizedBox(height: 32),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: _unlock,
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: _busy
                      ? const Padding(padding: EdgeInsets.all(28), child: CircularProgressIndicator(strokeWidth: 2.4))
                      : const Icon(Icons.fingerprint, size: 40, color: AppColors.ink),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Tap to unlock', style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
