import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/catalog_models.dart';
import '../../../catalog/presentation/widgets/catalog_widgets.dart';

class ReminderKindTile extends StatelessWidget {
  const ReminderKindTile({super.key, required this.kind, required this.selected, required this.onTap});
  final ReminderKind kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.chipBlue : AppColors.line, width: selected ? 2 : 1),
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
            Text(kind.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}
