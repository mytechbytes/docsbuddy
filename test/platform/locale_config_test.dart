import 'dart:io';

import 'package:docsbuddy/core/l10n/app_language.dart';
import 'package:flutter_test/flutter_test.dart';

/// The OS only offers (and only hands the app) languages the platform
/// config declares. Each list below must match [AppLanguage] — adding a
/// language in Dart alone would make it invisible in Android's per-app
/// language picker and unrecognised by iOS.
void main() {
  // Platform tags: Chinese is declared by script, the rest by language.
  final platformTags = {for (final l in AppLanguage.explicit) l.code == 'zh' ? 'zh-Hans' : l.code};

  test('Android declares every language for the per-app language setting', () {
    final xml = File('android/app/src/main/res/xml/locales_config.xml').readAsStringSync();
    final declared = RegExp(r'<locale android:name="([^"]+)"').allMatches(xml).map((m) => m.group(1)!).toSet();
    expect(declared, platformTags);
    expect(File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
        contains('android:localeConfig="@xml/locales_config"'));
  });

  for (final plist in ['ios/Runner/Info.plist', 'macos/Runner/Info.plist']) {
    test('$plist declares every language', () {
      final text = File(plist).readAsStringSync();
      final block = RegExp(r'<key>CFBundleLocalizations</key>\s*<array>(.*?)</array>', dotAll: true).firstMatch(text);
      expect(block, isNotNull, reason: 'CFBundleLocalizations is missing');
      final declared = RegExp(r'<string>([^<]+)</string>').allMatches(block!.group(1)!).map((m) => m.group(1)!).toSet();
      expect(declared, platformTags);
    });
  }
}
