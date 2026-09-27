import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/features/auth/domain/auth_repository.dart';
import 'package:docsbuddy/features/profile/application/profile_providers.dart';
import 'package:docsbuddy/features/settings/application/change_password_controller.dart';
import 'package:docsbuddy/features/settings/application/settings_providers.dart';
import 'package:docsbuddy/features/settings/domain/notification_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_app.dart';

class _MockAuth extends Mock implements AuthRepository {}

void main() {
  group('NotificationPrefsController', () {
    late ProviderContainer container;
    setUp(() {
      container = makeContainer();
      container.listen(notificationPrefsProvider, (_, _) {});
    });

    NotificationPrefs prefs() => container.read(notificationPrefsProvider).requireValue;

    test('toggles channels', () async {
      await container.read(notificationPrefsProvider.future);
      await container.read(notificationPrefsProvider.notifier).setChannel(NotificationChannel.whatsapp, true);
      expect(prefs().has(NotificationChannel.whatsapp), isTrue);
      await container.read(notificationPrefsProvider.notifier).setChannel(NotificationChannel.push, false);
      expect(prefs().has(NotificationChannel.push), isFalse);
    });

    test('default offsets are sorted, and must not be empty', () async {
      await container.read(notificationPrefsProvider.future);
      final c = container.read(notificationPrefsProvider.notifier);
      expect(() => c.setDefaultOffsets({}), throwsA(isA<ValidationFailure>()));
      await c.setDefaultOffsets({1, 60, 14});
      expect(prefs().defaultOffsets, [60, 14, 1]);
    });

    test('quiet hours are stored as zero-padded HH:mm', () async {
      await container.read(notificationPrefsProvider.future);
      await container
          .read(notificationPrefsProvider.notifier)
          .setQuietHours((hour: 23, minute: 5), (hour: 6, minute: 30));
      expect((prefs().quietStart, prefs().quietEnd), ('23:05', '06:30'));
    });

    test('sendTestNotification reports a blocked permission', () async {
      final notifications = RecordingNotificationService()..permission = false;
      final c = makeContainer(overrides: testOverrides(notifications: notifications));
      expect(await c.read(sendTestNotificationProvider)(), isFalse);
      expect(notifications.tests, 1);
    });
  });

  group('ChangePasswordController', () {
    late _MockAuth auth;
    late ProviderContainer container;

    setUp(() async {
      auth = _MockAuth();
      container = makeContainer(overrides: testOverrides(auth: auth));
      container.listen(changePasswordControllerProvider, (_, _) {});
      await container.read(profileProvider.future); // email: you@docsbuddy.app
    });

    Future<void> submit(String current, String fresh, [String? confirm]) => container
        .read(changePasswordControllerProvider.notifier)
        .submit(current: current, fresh: fresh, confirmation: confirm ?? fresh);

    test('validates before touching the backend', () async {
      await expectLater(submit('old', 'short'), throwsA(isA<ValidationFailure>()));
      await expectLater(submit('old', 'longenough', 'mismatch'), throwsA(isA<ValidationFailure>()));
      verifyZeroInteractions(auth);
    });

    test('a wrong current password is reported as such', () async {
      when(() => auth.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const AuthFailure('Invalid login credentials'));
      await expectLater(
        submit('wrong', 'longenough'),
        throwsA(isA<AuthFailure>().having((f) => f.message, 'message', 'Current password is incorrect.')),
      );
      verifyNever(() => auth.updatePassword(any()));
    });

    test('re-authenticates then updates', () async {
      when(() => auth.signInWithPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async {});
      when(() => auth.updatePassword('longenough')).thenAnswer((_) async {});
      await submit('current', 'longenough');
      verifyInOrder([
        () => auth.signInWithPassword(email: 'you@docsbuddy.app', password: 'current'),
        () => auth.updatePassword('longenough'),
      ]);
      expect(container.read(changePasswordControllerProvider), isA<AsyncData<void>>());
    });
  });
}
