import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';

class OtpVerifyPage extends ConsumerStatefulWidget {
  const OtpVerifyPage({super.key, required this.email});

  final String email;

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  static const _length = 6;
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _secondsLeft = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _countdownText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _verify() async {
    final ok = await ref.read(authControllerProvider.notifier).verifyResetCode(widget.email, _controller.text);
    if (ok && mounted) context.go('/reset-password');
  }

  Future<void> _resend() async {
    final ok = await ref.read(authControllerProvider.notifier).sendResetCode(widget.email);
    if (ok) _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(ref, context);
    final loading = ref.watch(authControllerProvider).isLoading;
    final code = _controller.text;

    return AuthScaffold(
      showLogo: false,
      children: [
        const SizedBox(height: 14),
        const Center(child: HeroBadge(background: AppColors.greenSoft, foreground: AppColors.green, icon: Icons.mail_outline)),
        const SizedBox(height: 22),
        AuthHero(title: 'Check your inbox', subtitle: 'We sent a 6-digit code to ${widget.email}. Enter it below to continue.'),
        const SizedBox(height: 22),
        // Hidden input overlaying the visual cells.
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < _length; i++) _OtpCell(digit: i < code.length ? code[i] : '', active: i == code.length),
              ],
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  autofocus: true,
                  showCursor: false,
                  keyboardType: TextInputType.number,
                  maxLength: _length,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        PrimaryButton(label: 'Verify', isLoading: loading, onPressed: _verify),
        const SizedBox(height: 18),
        Center(
          child: _secondsLeft > 0
              ? Text.rich(TextSpan(
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                  children: [
                    const TextSpan(text: "Didn't receive it? Resend in "),
                    TextSpan(text: _countdownText, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700)),
                  ],
                ))
              : InlineLink(lead: "Didn't receive it? ", action: 'Resend code', onTap: _resend),
        ),
      ],
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({required this.digit, required this.active});
  final String digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color border = digit.isNotEmpty
        ? AppColors.ink
        : active
            ? AppColors.chipBlue
            : AppColors.fieldBorder;
    return Container(
      width: 46,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.5),
        boxShadow: active ? [BoxShadow(color: AppColors.chipBlue.withValues(alpha: 0.13), blurRadius: 0, spreadRadius: 4)] : null,
      ),
      child: Text(digit, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ink)),
    );
  }
}
