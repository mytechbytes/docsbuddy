import 'dart:typed_data';

import '../../../core/data/file_storage.dart';
import '../../../core/data/supabase/supabase_guard.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/profile.dart';
import 'profile_remote_data_source.dart';

/// Pure row → model conversion (auth-side facts come in separately).
abstract final class ProfileMapper {
  static Profile fromRow(Json r, {String? authEmail, bool verified = false}) => Profile(
        id: r['id'] as String,
        displayName: (r['display_name'] as String?) ?? authEmail?.split('@').first ?? 'You',
        email: (r['email'] as String?) ?? authEmail ?? '',
        avatarUrl: r['avatar_url'] as String?,
        phone: r['phone'] as String?,
        timezone: r['timezone'] as String?,
        verified: verified,
      );
}

/// `public.users` keyed by the auth uid; avatar bytes go to the family-scoped
/// bucket folder (storage RLS requires the leading `{family_id}` segment).
class RemoteProfileRepository implements ProfileRepository {
  RemoteProfileRepository(
    this._remote,
    this._files, {
    required this.localTimezone,
    Clock clock = DateTime.now,
  }) : _now = clock;

  final ProfileRemoteDataSource _remote;
  final FileStorage _files;
  /// The device's IANA timezone (injected so the repository stays testable).
  final Future<String> Function() localTimezone;
  final Clock _now;

  String get _uid => _remote.currentUserId ?? (throw const AuthFailure('Not signed in.'));

  Profile _map(Json row) =>
      ProfileMapper.fromRow(row, authEmail: _remote.authEmail, verified: _remote.emailConfirmed);

  @override
  Future<Profile> get() => guardBackend(() async => _map(await _remote.fetch(_uid)));

  @override
  Future<Profile> update({String? displayName, String? phone}) => guardBackend(() async {
        final row = await _remote.update(_uid, {
          if (displayName != null && displayName.trim().isNotEmpty) 'display_name': displayName.trim(),
          if (phone != null) 'phone': phone.trim().isEmpty ? null : phone.trim(),
        });
        return _map(row);
      });

  @override
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType}) =>
      guardBackend(() async {
        final uid = _uid;
        final family = await _remote.firstFamilyId();
        if (family == null) throw const ValidationFailure('Join or create a family first.');

        final old = (await _remote.fetch(uid))['avatar_url'] as String?;
        final path = '$family/avatars/$uid/${_now().millisecondsSinceEpoch}_${safeFileName(fileName)}';
        await _files.upload(path, bytes, mimeType: mimeType);
        final row = await _remote.update(uid, {'avatar_url': path});

        if (isBucketPath(old)) {
          try {
            await _files.remove(old!);
          } catch (_) {/* leave the orphan */}
        }
        return _map(row);
      });

  @override
  Future<void> syncTimezone() async {
    try {
      await _remote.update(_uid, {'timezone': await localTimezone()});
    } catch (_) {/* best-effort */}
  }
}
