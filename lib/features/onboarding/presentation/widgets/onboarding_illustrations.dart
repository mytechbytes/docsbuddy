import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

// ─── Shared illustration primitives ──────────────────────────────────────────

Color _shade(Color c, int delta) => Color.fromARGB(
      255,
      ((c.r * 255).round() + delta).clamp(0, 255),
      ((c.g * 255).round() + delta).clamp(0, 255),
      ((c.b * 255).round() + delta).clamp(0, 255),
    );

/// Round, softly-tinted backdrop common to every onboarding illustration
/// (`IlloStage` in the handoff).
class IlloStage extends StatelessWidget {
  const IlloStage({super.key, required this.tint, this.size = 250, required this.child});

  final Color tint;
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 0.72,
          colors: [tint, _shade(tint, -6), AppColors.bg],
          stops: const [0, 0.7, 1],
        ),
      ),
      child: Center(child: child),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.bg, required this.fg, required this.icon, this.size = 28});

  final Color bg;
  final Color fg;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(size * 0.32)),
      child: Icon(icon, size: size * 0.55, color: fg),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(999)),
      child: Text(
        '${days}d',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: AppColors.chipBlue, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ImgPlaceholder extends StatelessWidget {
  const _ImgPlaceholder({required this.label, required this.tint});

  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: const TextStyle(fontSize: 8, color: Color(0xFF7A6A53), fontWeight: FontWeight.w600)),
    );
  }
}

BoxShadow get _softShadow =>
    BoxShadow(color: const Color(0xFF0F1E37).withValues(alpha: 0.14), blurRadius: 18, offset: const Offset(0, 6));

double _rad(double deg) => deg * math.pi / 180;

// ─── 1 · Welcome — tilted dashboard collage ──────────────────────────────────

class IlloWelcome extends StatelessWidget {
  const IlloWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return IlloStage(
      tint: const Color(0xFFEAF0FB),
      child: SizedBox(
        width: 230,
        height: 200,
        child: Stack(
          children: [
            // Navy card behind
            Positioned(
              left: 8,
              top: 18,
              child: Transform.rotate(
                angle: _rad(-6),
                child: _StatCard(
                  gradient: AppColors.cardNavy,
                  width: 150,
                  height: 110,
                  label: 'Active Invoices',
                  value: '23',
                  trailing: const Icon(Icons.description_outlined, size: 16, color: Colors.white),
                ),
              ),
            ),
            // Teal card front-right
            Positioned(
              right: 0,
              top: 0,
              child: Transform.rotate(
                angle: _rad(8),
                child: _StatCard(
                  gradient: AppColors.cardTeal,
                  width: 130,
                  height: 100,
                  label: 'Secured',
                  value: '14',
                ),
              ),
            ),
            // Floating reminder pill
            Positioned(
              left: 20,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [_softShadow],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _IconBubble(
                      bg: AppColors.insuranceBg,
                      fg: AppColors.insuranceFg,
                      icon: Icons.shield_outlined,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Insurance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink)),
                        Text('in 25 days', style: TextStyle(fontSize: 9.5, color: AppColors.muted)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const _DayPill(days: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.gradient,
    required this.width,
    required this.height,
    required this.label,
    required this.value,
    this.trailing,
  });

  final List<Color> gradient;
  final double width;
  final double height;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [BoxShadow(color: const Color(0xFF0F1E37).withValues(alpha: 0.18), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, height: 1.1, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.85))),
          Text(value, style: const TextStyle(fontSize: 30, height: 1.05, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.6)),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

// ─── 2 · Track Assets — variety of asset rows ────────────────────────────────

class IlloAssets extends StatelessWidget {
  const IlloAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return IlloStage(
      tint: const Color(0xFFE7F4EC),
      child: SizedBox(
        width: 240,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _assetRow('kitchen', 'Samsung 340L Fridge', 'Kitchen', const Color(0xFFE8D9C4), -66, -4),
            _assetRow('phone', 'iPhone 15 Pro', 'Smartphone', const Color(0xFFDEE2EA), -12, 0),
            _assetRow('bike', 'Royal Enfield Classic', 'Vehicles', const Color(0xFFDDE9E2), 42, 4),
          ],
        ),
      ),
    );
  }

  Widget _assetRow(String img, String label, String sub, Color tint, double dy, double rotDeg) {
    return Transform.translate(
      offset: Offset(0, dy),
      child: Transform.rotate(
        angle: _rad(rotDeg),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEF2F8)),
            boxShadow: [BoxShadow(color: const Color(0xFF0F1E37).withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(
            children: [
              _ImgPlaceholder(label: img, tint: tint),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _CategoryChip(sub),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 3 · Smart Reminders — threshold timeline ────────────────────────────────

class IlloReminders extends StatelessWidget {
  const IlloReminders({super.key});

  @override
  Widget build(BuildContext context) {
    const markers = [
      (0.06, '−30d'),
      (0.40, '−7d'),
      (0.76, '−1d'),
      (0.94, 'Due'),
    ];
    return IlloStage(
      tint: const Color(0xFFFDEBEC),
      child: SizedBox(
        width: 240,
        height: 200,
        child: Stack(
          children: [
            // Hero "next due" card
            Positioned(
              left: 8,
              right: 8,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [_softShadow],
                ),
                child: Row(
                  children: [
                    const _IconBubble(bg: AppColors.pollutionBg, fg: AppColors.pollutionFg, icon: Icons.eco_outlined, size: 36),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Pollution due', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
                          Text('07 Jun · Bike', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    const _DayPill(days: 15),
                  ],
                ),
              ),
            ),
            // Gradient timeline bar
            Positioned(
              left: 14,
              right: 14,
              top: 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [AppColors.red, Color(0xFFFBD58A), AppColors.green],
                    stops: [0, 0.6, 1],
                  ),
                ),
              ),
            ),
            // Markers
            for (final m in markers)
              Positioned(
                left: 14 + (240 - 28) * m.$1 - 6,
                top: 90,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ink, width: 2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(m.$2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ],
                ),
              ),
            // Floating bell
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFF0F1E37).withValues(alpha: 0.3), blurRadius: 22, offset: const Offset(0, 10))],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_outlined, size: 24, color: Colors.white),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 4 · Family Sharing — avatar orbit ───────────────────────────────────────

class IlloFamily extends StatelessWidget {
  const IlloFamily({super.key});

  @override
  Widget build(BuildContext context) {
    const positions = [Alignment(0, -1), Alignment(1, 0), Alignment(0, 1), Alignment(-1, 0)];
    return IlloStage(
      tint: const Color(0xFFEEF3FB),
      child: SizedBox(
        width: 220,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dashed orbit
            CustomPaint(size: const Size(180, 180), painter: _DashedCirclePainter()),
            // Center notification card
            Container(
              width: 130,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [_softShadow],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_outlined, size: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  const Text('Shared with family', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  const Text('Insurance · 25 d', style: TextStyle(fontSize: 9.5, color: AppColors.muted)),
                ],
              ),
            ),
            // Avatars on orbit
            for (var i = 0; i < 4; i++)
              Align(
                alignment: positions[i],
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.familyAvatars[i],
                    ),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [BoxShadow(color: const Color(0xFF0F1E37).withValues(alpha: 0.18), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF0F1E37).withValues(alpha: 0.18);
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    const dashCount = 40;
    const sweep = (2 * math.pi) / dashCount;
    for (var i = 0; i < dashCount; i++) {
      final start = i * sweep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
