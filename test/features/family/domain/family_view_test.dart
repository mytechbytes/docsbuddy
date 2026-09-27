import 'package:docsbuddy/features/family/domain/family_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const owner = FamilyMember(userId: 'o', displayName: 'Owner', role: FamilyRole.owner);
  const admin = FamilyMember(userId: 'a', displayName: 'Admin', role: FamilyRole.admin);
  const member = FamilyMember(userId: 'm', displayName: 'Member', role: FamilyRole.member, phone: '+91 98123-45678');
  const family = Family(id: 'f', name: 'Home', ownerId: 'o');

  FamilyView viewAs(String me) =>
      FamilyView(family: family, members: const [owner, admin, member], myUserId: me);

  test('admins manage other non-owner members; never themselves or the owner', () {
    expect(viewAs('a').canManage(member), isTrue);
    expect(viewAs('a').canManage(owner), isFalse);
    expect(viewAs('a').canManage(admin), isFalse);
    expect(viewAs('o').canManage(admin), isTrue);
    expect(viewAs('m').canManage(admin), isFalse);
    expect(viewAs('stranger').canManage(member), isFalse);
  });

  test('member helpers', () {
    expect(member.whatsappNumber, '919812345678');
    expect(member.initial, 'M');
    expect(const FamilyMember(userId: 'x', displayName: ' ', role: FamilyRole.viewer).initial, '?');
    expect(FamilyRole.fromName('viewer'), FamilyRole.viewer);
    expect(FamilyRole.fromName(null), FamilyRole.member);
    expect(FamilyRole.assignable, isNot(contains(FamilyRole.owner)));
  });
}
