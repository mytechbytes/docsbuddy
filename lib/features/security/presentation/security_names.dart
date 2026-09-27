import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/security_models.dart';

extension BiometricKindName on BiometricKind {
  String displayName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      BiometricKind.face => l.biometricFace,
      BiometricKind.fingerprint => l.biometricFingerprint,
      BiometricKind.device => l.biometricDevice,
    };
  }
}
