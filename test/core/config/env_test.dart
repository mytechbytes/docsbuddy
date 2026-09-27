import 'package:docsbuddy/core/config/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('iOS redirects through the custom scheme until universal links are set up', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(Env.authRedirectUrl, Env.authRedirectScheme);
  });

  test('Android uses the verified App Link', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(Env.authRedirectUrl, Env.authRedirectAppLink);
  });
}
