import 'package:docsbuddy/core/error/app_failure.dart';
import 'package:docsbuddy/core/providers/core_providers.dart';
import 'package:docsbuddy/features/family/application/family_controller.dart';
import 'package:docsbuddy/features/family/domain/family_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_app.dart';

void main() {
  late ProviderContainer container;
  setUp(() {
    container = makeContainer();
    container.listen(familyControllerProvider, (_, _) {});
  });

  FamilyController family() => container.read(familyControllerProvider.notifier);

  Future<FamilyView> view() => container.read(familyControllerProvider.future);

  test('starts without a family', () async {
    expect((await view()).hasFamily, isFalse);
  });

  test('creating validates the name and bumps the family scope', () async {
    await view();
    await expectLater(family().createFamily('  '), throwsA(isA<ValidationFailure>()));
    expect(container.read(familyScopeProvider), 0);

    await family().createFamily(' Kumar Family ');
    final v = container.read(familyControllerProvider).requireValue;
    expect(v.family!.name, 'Kumar Family');
    expect(v.me!.role, FamilyRole.owner);
    expect(container.read(familyScopeProvider), 1);
  });

  test('joining normalises the code; owner is protected from changes', () async {
    await view();
    await family().acceptInvite(' abcd1234 ');
    final v = container.read(familyControllerProvider).requireValue;
    expect(v.members, hasLength(2));
    final owner = v.members.firstWhere((m) => m.role == FamilyRole.owner);

    await expectLater(family().changeRole(owner, FamilyRole.viewer), throwsA(isA<ValidationFailure>()));
    await expectLater(family().removeMember(owner), throwsA(isA<ValidationFailure>()));
  });

  test('leaving clears the family and bumps the scope', () async {
    await view();
    await family().createFamily('Home');
    await family().leave();
    expect(container.read(familyControllerProvider).requireValue.hasFamily, isFalse);
    expect(container.read(familyScopeProvider), 2);
  });

  test('inviting without a family is a validation failure', () async {
    await view();
    expect(() => family().invite(), throwsA(isA<ValidationFailure>()));
  });
}
