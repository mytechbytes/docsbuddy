import 'package:flutter/material.dart';

import '../../../catalog/domain/catalog_models.dart';
import '../../../catalog/presentation/widgets/catalog_widgets.dart';
import '../../../../core/theme/app_theme.dart';

class ReminderKindTile extends StatelessWidget {
  const ReminderKindTile({super.key, required this.kind, required this.selected, required this.onTap});
  final ReminderKind kind;
  final bool selected;
  final VoidCallback onTap;

  /// Shortest a tile can be at the user's font size: its border, the 34dp icon
  /// and one line of label. A grid must not make it shorter.
  static double minHeight(BuildContext context) =>
      4 + 34 + 6 + MediaQuery.textScalerOf(context).scale(11) * 1.5 + 8;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? context.palette.accent : context.palette.border, width: selected ? 2 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: kind.bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(kind.icon, size: 18, color: kind.fg),
            ),
            const SizedBox(height: 6),
            Text(kind.displayName(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.palette.text)),
          ],
        ),
      ),
    );
  }
}
