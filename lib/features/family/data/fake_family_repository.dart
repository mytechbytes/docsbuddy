import 'dart:math';

import 'family_models.dart';
import 'family_repository.dart';

/// In-memory family store for local dev / tests / the CI APK. Starts with no
/// family so the empty state shows; mutations update an internal model.
class FakeFamilyRepository implements FamilyRepository {
  Family? _family;
  final List<FamilyMember> _members = [];
  final _rng = Random();

  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 500));

  String _code() {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(6, (_) => alphabet[_rng.nextInt(alphabet.length)]).join();
  }

  @override
  Future<Family?> currentFamily() async {
    await _delay();
    return _family;
  }

  @override
  Future<List<FamilyMember>> members(String familyId) async {
    await _delay();
    return List.unmodifiable(_members);
  }

  @override
  Future<Family> createFamily(String name) async {
    await _delay();
    if (name.trim().isEmpty) throw const FamilyFailure('Please enter a family name.');
    final family = Family(id: 'fam_${_rng.nextInt(99999)}', name: name.trim(), ownerId: 'me');
    _family = family;
    _members
      ..clear()
      ..add(const FamilyMember(userId: 'me', displayName: 'You', role: FamilyRole.owner));
    return family;
  }

  @override
  Future<FamilyInvite> createInvite({required String familyId, required FamilyRole role}) async {
    await _delay();
    return FamilyInvite(code: _code(), role: role, expiresAt: DateTime.now().add(const Duration(days: 7)));
  }

  @override
  Future<Family> acceptInvite(String code) async {
    await _delay();
    if (code.trim().length != 6) throw const FamilyFailure('Enter the 6-character invite code.');
    // Demo behaviour: joining lands you in a shared family with an existing owner.
    _family ??= const Family(id: 'fam_shared', name: 'Shared Home', ownerId: 'owner');
    if (_members.isEmpty) {
      _members.add(const FamilyMember(userId: 'owner', displayName: 'Anand Kumar', role: FamilyRole.owner));
    }
    _members.add(const FamilyMember(userId: 'me', displayName: 'You', role: FamilyRole.member));
    return _family!;
  }

  @override
  Future<void> leaveFamily(String familyId) async {
    await _delay();
    _family = null;
    _members.clear();
  }
}
