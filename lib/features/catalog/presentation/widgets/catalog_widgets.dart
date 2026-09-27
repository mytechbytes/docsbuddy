import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/catalog/application/catalog_providers.dart';
import '../../features/catalog/data/catalog_models.dart';
import '../theme/app_colors.dart';

/// Rounded icon tile coloured by reminder kind (the design's `IconBubble`).
class IconBubble extends StatelessWidget {
  const IconBubble({super.key, required this.kind, this.size = 44});
  final ReminderKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: kind.bg, borderRadius: BorderRadius.circular(size * 0.3)),
      child: Icon(kind.icon, size: size * 0.5, color: kind.fg),
    );
  }
}

/// Asset photo thumbnail: resolves the stored reference (signed URL for the
/// private bucket) and renders it rounded; shows [fallback] until resolved,
/// when there's no photo, or when loading fails.
class AssetThumb extends ConsumerWidget {
  const AssetThumb({
    super.key,
    required this.imageRef,
    required this.fallback,
    this.size = 44,
    this.width,
    this.height,
    this.radius,
  });

  final String? imageRef;
  final Widget fallback;

  /// Square dimension; [width]/[height] override it for banners/heroes
  /// (null width = fill the parent).
  final double size;
  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = radius ?? size * 0.27;
    if (imageRef == null || imageRef!.isEmpty) return fallback;
    final url = ref.watch(assetImageUrlProvider(imageRef!)).valueOrNull;
    if (url == null) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Image.network(
        url,
        width: width ?? size,
        height: height ?? size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}

/// Days-remaining pill, green → amber → red as the due date approaches.
class DayPill extends StatelessWidget {
  const DayPill({super.key, required this.daysLeft});
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final (Color color, String text) = switch (daysLeft) {
      < 0 => (AppColors.red, 'Overdue'),
      0 => (AppColors.red, 'Today'),
      <= 7 => (AppColors.amber, '${daysLeft}d'),
      <= 30 => (AppColors.green, '${daysLeft}d'),
      _ => (AppColors.green, '${daysLeft}d'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

/// Small blue category chip.
class CategoryChip extends StatelessWidget {
  const CategoryChip(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFEEF3FB), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(color: AppColors.chipBlue, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
