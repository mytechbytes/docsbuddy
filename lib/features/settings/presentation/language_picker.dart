import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_language.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/language_controller.dart';
import '../../../core/theme/app_theme.dart';

/// What the Settings row shows for [language]: its own name, or "Automatic".
String languageLabel(BuildContext context, AppLanguage language) =>
    language.nativeName ?? context.l10n.languageAutomatic;

/// Bottom sheet to choose the app language: "Automatic" (follow the device)
/// first, then each translation by its own name so it can be found whatever
/// language the app is currently in.
Future<void> pickLanguage(BuildContext context, WidgetRef ref) async {
  final current = ref.read(languageProvider);
  final picked = await showModalBottomSheet<AppLanguage>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 8),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(context.l10n.languageSheetTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.palette.text)),
            ),
          ),
          for (final language in [AppLanguage.system, ...AppLanguage.explicit])
            ListTile(
              title: Text(languageLabel(context, language), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: language.isAutomatic ? Text(context.l10n.languageAutomaticHint) : null,
              trailing: language == current ? Icon(Icons.check, color: context.palette.success) : null,
              onTap: () => Navigator.of(context).pop(language),
            ),
        ],
      ),
    ),
  );
  if (picked != null) await ref.read(languageProvider.notifier).set(picked);
}
