import 'dart:typed_data';

import '../domain/profile.dart';

/// In-memory profile for local dev / tests / the offline build.
class FakeProfileRepository implements ProfileRepository {
  Profile _profile = const Profile(
    id: 'u_local',
    displayName: 'DocsBuddy User',
    email: 'you@docsbuddy.app',
    verified: true,
  );

  @override
  Future<Profile> get() async => _profile;

  @override
  Future<Profile> update({String? displayName, String? phone}) async {
    return _profile = _profile.copyWith(
      displayName: displayName?.trim().isNotEmpty == true ? displayName!.trim() : _profile.displayName,
      phone: phone == null ? _profile.phone : (phone.trim().isEmpty ? null : phone.trim()),
    );
  }

  @override
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType}) async {
    return _profile = _profile.copyWith(avatarUrl: 'local/avatar/$fileName');
  }

  @override
  Future<void> syncTimezone() async {}
}
