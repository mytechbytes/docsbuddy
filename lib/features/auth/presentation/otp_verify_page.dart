import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/buttons.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_widgets.dart';
import '../../../routing/app_routes.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';

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
    if (ok && mounted) context.go(AppRoutes.resetPassword);
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
        Center(child: HeroBadge(background: context.palette.successSoft, foreground: context.palette.success, icon: Icons.mail_outline)),
        const SizedBox(height: 22),
        AuthHero(title: context.l10n.authOtpTitle, subtitle: context.l10n.authOtpSubtitle(widget.email)),
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
        PrimaryButton(label: context.l10n.authOtpVerify, isLoading: loading, onPressed: _verify),
        const SizedBox(height: 18),
        Center(
          child: _secondsLeft > 0
              ? Text.rich(TextSpan(
                  style: TextStyle(fontSize: 13, color: context.palette.textMuted),
                  children: [
                    TextSpan(text: context.l10n.authOtpResendIn),
                    TextSpan(text: _countdownText, style: TextStyle(color: context.palette.text, fontWeight: FontWeight.w700)),
                  ],
                ))
              : InlineLink(lead: context.l10n.authOtpNotReceivedLead, action: context.l10n.authOtpResend, onTap: _resend),
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
        ? context.palette.text
        : active
            ? context.palette.accent
            : context.palette.fieldBorder;
    return Container(
      width: 46,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.5),
        boxShadow: active ? [BoxShadow(color: context.palette.accent.withValues(alpha: 0.13), blurRadius: 0, spreadRadius: 4)] : null,
      ),
      child: Text(digit, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: context.palette.text)),
    );
  }
}
