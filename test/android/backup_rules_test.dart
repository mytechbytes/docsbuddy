import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The Keystore key behind flutter_secure_storage's files isn't backed up, so a restored copy can never be decrypted;
/// pin the exclusions so a manifest edit can't bring back a stuck start-up screen after a reinstall.
void main() {
  const secureFiles = ['FlutterSecureStorage.xml', 'FlutterSecureKeyStorage.xml'];
  String read(String path) => File(path).readAsStringSync();

  test('both backup mechanisms exclude the secure-storage files', () {
    for (final file in ['backup_rules.xml', 'data_extraction_rules.xml']) {
      final xml = read('android/app/src/main/res/xml/$file');
      for (final secure in secureFiles) {
        expect(xml, contains('<exclude domain="sharedpref" path="$secure" />'), reason: '$file must exclude $secure');
      }
    }
    // Android 12+ also has a separate device-to-device transfer section.
    final rules = read('android/app/src/main/res/xml/data_extraction_rules.xml');
    expect(rules, contains('<device-transfer>'));
  });

  test('the manifest points at both rule files', () {
    final manifest = read('android/app/src/main/AndroidManifest.xml');
    expect(manifest, contains('android:fullBackupContent="@xml/backup_rules"'));
    expect(manifest, contains('android:dataExtractionRules="@xml/data_extraction_rules"'));
  });
}
