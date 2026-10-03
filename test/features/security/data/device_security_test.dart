import 'package:docsbuddy/features/security/data/device_security.dart';
import 'package:docsbuddy/features/security/domain/security_models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockLocalAuth extends Mock implements LocalAuthentication {}

void main() {
  late _MockLocalAuth auth;
  late LocalAuthBiometricAuthenticator biometrics;

  setUp(() {
    auth = _MockLocalAuth();
    biometrics = LocalAuthBiometricAuthenticator(auth);
  });

  void authenticateThrows(Object error) => when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenThrow(error);

  void authenticateReturns(bool value) => when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
          persistAcrossBackgrounding: any(named: 'persistAcrossBackgrounding'),
        ),
      ).thenAnswer((_) async => value);

  group('authenticate', () {
    test('a recognised face or fingerprint is a success', () async {
      authenticateReturns(true);
      expect(await biometrics.authenticate('Unlock'), BiometricResult.success);
    });

    test('a face or fingerprint that was not recognised is a plain failure', () async {
      authenticateReturns(false);
      expect(await biometrics.authenticate('Unlock'), BiometricResult.failed);
    });

    test('the device PIN stays available as a fallback (biometricOnly is off)', () async {
      authenticateReturns(true);
      await biometrics.authenticate('Unlock');
      verify(() => auth.authenticate(
            localizedReason: 'Unlock',
            biometricOnly: false,
            persistAcrossBackgrounding: true,
          )).called(1);
    });

    // local_auth 3.x reports these by throwing — they used to escape the app's
    // adapter and leave the lock screen stuck on its spinner.
    test('backing out of the prompt is not an error', () async {
      for (final code in [
        LocalAuthExceptionCode.userCanceled,
        LocalAuthExceptionCode.systemCanceled,
        LocalAuthExceptionCode.userRequestedFallback,
        LocalAuthExceptionCode.timeout,
        LocalAuthExceptionCode.authInProgress,
      ]) {
        authenticateThrows(LocalAuthException(code: code));
        expect(await biometrics.authenticate('Unlock'), BiometricResult.canceled, reason: '$code');
      }
    });

    test('too many wrong attempts is reported as a lockout', () async {
      for (final code in [LocalAuthExceptionCode.temporaryLockout, LocalAuthExceptionCode.biometricLockout]) {
        authenticateThrows(LocalAuthException(code: code));
        expect(await biometrics.authenticate('Unlock'), BiometricResult.lockedOut, reason: '$code');
      }
    });

    test('a device with no screen lock or biometrics is unavailable', () async {
      for (final code in [
        LocalAuthExceptionCode.noCredentialsSet,
        LocalAuthExceptionCode.noBiometricsEnrolled,
        LocalAuthExceptionCode.noBiometricHardware,
      ]) {
        authenticateThrows(LocalAuthException(code: code));
        expect(await biometrics.authenticate('Unlock'), BiometricResult.unavailable, reason: '$code');
      }
    });

    test('anything else the platform reports is an error, never a thrown exception', () async {
      for (final code in [
        LocalAuthExceptionCode.uiUnavailable,
        LocalAuthExceptionCode.deviceError,
        LocalAuthExceptionCode.unknownError,
        LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable,
      ]) {
        authenticateThrows(LocalAuthException(code: code));
        expect(await biometrics.authenticate('Unlock'), BiometricResult.error, reason: '$code');
      }
    });

    test('a platform without biometrics (desktop, tests) is unavailable', () async {
      authenticateThrows(MissingPluginException());
      expect(await biometrics.authenticate('Unlock'), BiometricResult.unavailable);

      authenticateThrows(PlatformException(code: 'NotAvailable'));
      expect(await biometrics.authenticate('Unlock'), BiometricResult.unavailable);
    });
  });

  group('what the device offers', () {
    test('availability and kinds never throw', () async {
      when(() => auth.isDeviceSupported()).thenThrow(const LocalAuthException(code: LocalAuthExceptionCode.deviceError));
      when(() => auth.canCheckBiometrics).thenThrow(MissingPluginException());
      when(() => auth.getAvailableBiometrics()).thenThrow(const LocalAuthException(code: LocalAuthExceptionCode.deviceError));

      expect(await biometrics.isAvailable(), isFalse);
      expect(await biometrics.kinds(), isEmpty);
    });

    test('face, fingerprint and generic biometrics are told apart', () async {
      when(() => auth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.face, BiometricType.fingerprint, BiometricType.strong]);
      expect(await biometrics.kinds(), [BiometricKind.face, BiometricKind.fingerprint, BiometricKind.device]);
    });

    test('a device with only a screen lock is available but has no biometric kinds', () async {
      when(() => auth.isDeviceSupported()).thenAnswer((_) async => true);
      when(() => auth.getAvailableBiometrics()).thenAnswer((_) async => const []);
      expect(await biometrics.isAvailable(), isTrue);
      expect(await biometrics.kinds(), isEmpty);
    });
  });

  group('SharedPrefsSecurityPrefsStore', () {
    Future<SharedPrefsSecurityPrefsStore> storeWith(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      return SharedPrefsSecurityPrefsStore(await SharedPreferences.getInstance());
    }

    test('round-trips the lock and its timeout', () async {
      final store = await storeWith({});
      expect(store.load(), const SecurityPrefs());

      await store.save(const SecurityPrefs(appLock: true, autoLockMinutes: 5));
      expect(store.load(), const SecurityPrefs(appLock: true, autoLockMinutes: 5));
    });

    test('someone who switched on the old "Unlock with biometrics" now has app lock on', () async {
      // That switch used to do nothing on its own; turning it on was the
      // person asking for exactly the lock this now provides.
      final store = await storeWith({'security_biometric_unlock': true});
      expect(store.load().appLock, isTrue);
    });

    test('saving drops the retired switch so it cannot come back', () async {
      SharedPreferences.setMockInitialValues({'security_biometric_unlock': true});
      final prefs = await SharedPreferences.getInstance();
      final store = SharedPrefsSecurityPrefsStore(prefs);

      await store.save(const SecurityPrefs(appLock: false));

      expect(prefs.containsKey('security_biometric_unlock'), isFalse);
      expect(store.load().appLock, isFalse, reason: 'turning the lock off must stick');
    });
  });
}
