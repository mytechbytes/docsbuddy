import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The signed-in user's profile — maps `public.users` plus auth-side facts
/// (email, verification).
@immutable
class Profile {
  const Profile({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.timezone,
    this.verified = false,
  });

  final String id;
  final String displayName;
  final String email;

  /// Bucket path or absolute URL — render via the shared image resolver.
  final String? avatarUrl;

  /// E.164 — also the WhatsApp reminder destination.
  final String? phone;
  final String? timezone;
  final bool verified;

  String get initial => displayName.trim().isEmpty ? '?' : displayName.trim()[0].toUpperCase();
}

abstract interface class ProfileRepository {
  Future<Profile> get();
  Future<Profile> update({String? displayName, String? phone});
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType});

  /// Stores the device timezone on the profile (used by server-side
  /// notification scheduling). Best-effort; failures are swallowed.
  Future<void> syncTimezone();
}

/// In-memory profile for local dev / tests / the offline build.
class FakeProfileRepository implements ProfileRepository {
  Profile _profile = const Profile(
    id: 'u_local',
    displayName: 'DocsBuddy User',
    email: 'you@docsbuddy.app',
    phone: null,
    verified: true,
  );

  @override
  Future<Profile> get() async => _profile;

  @override
  Future<Profile> update({String? displayName, String? phone}) async {
    return _profile = Profile(
      id: _profile.id,
      displayName: displayName?.trim().isNotEmpty == true ? displayName!.trim() : _profile.displayName,
      email: _profile.email,
      avatarUrl: _profile.avatarUrl,
      phone: phone?.trim().isNotEmpty == true ? phone!.trim() : _profile.phone,
      timezone: _profile.timezone,
      verified: _profile.verified,
    );
  }

  @override
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType}) async {
    return _profile = Profile(
      id: _profile.id,
      displayName: _profile.displayName,
      email: _profile.email,
      avatarUrl: 'local/avatar/$fileName',
      phone: _profile.phone,
      timezone: _profile.timezone,
      verified: _profile.verified,
    );
  }

  @override
  Future<void> syncTimezone() async {}
}

/// Real profile: `public.users` row keyed by the auth uid; avatar bytes go to
/// the family-scoped bucket folder (storage RLS requires the leading
/// `{family_id}` segment).
class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(this._client);

  final SupabaseClient _client;
  static const _bucket = 'docsbuddy-files';

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } on StorageException catch (e) {
      throw Exception(e.message);
    }
  }

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw Exception('Not signed in.');
    return id;
  }

  Profile _profile(Map<String, dynamic> r) {
    final user = _client.auth.currentUser;
    return Profile(
      id: r['id'] as String,
      displayName: (r['display_name'] as String?) ?? user?.email?.split('@').first ?? 'You',
      email: (r['email'] as String?) ?? user?.email ?? '',
      avatarUrl: r['avatar_url'] as String?,
      phone: r['phone'] as String?,
      timezone: r['timezone'] as String?,
      verified: user?.emailConfirmedAt != null,
    );
  }

  @override
  Future<Profile> get() => _guard(() async {
        final row = await _client
            .from('users')
            .select('id, display_name, email, avatar_url, phone, timezone')
            .eq('id', _uid)
            .single();
        return _profile(row);
      });

  @override
  Future<Profile> update({String? displayName, String? phone}) => _guard(() async {
        final row = await _client
            .from('users')
            .update({
              if (displayName != null && displayName.trim().isNotEmpty) 'display_name': displayName.trim(),
              if (phone != null) 'phone': phone.trim().isEmpty ? null : phone.trim(),
            })
            .eq('id', _uid)
            .select('id, display_name, email, avatar_url, phone, timezone')
            .single();
        return _profile(row);
      });

  @override
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType}) =>
      _guard(() async {
        final families = await _client.from('families').select('id').limit(1);
        if (families.isEmpty) throw Exception('Join or create a family first.');
        final fam = families.first['id'] as String;

        final old = (await _client.from('users').select('avatar_url').eq('id', _uid).single())['avatar_url'] as String?;
        final safe = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
        final path = '$fam/avatars/$_uid/${DateTime.now().millisecondsSinceEpoch}_$safe';
        await _client.storage.from(_bucket).uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(contentType: mimeType, upsert: false),
            );

        final row = await _client
            .from('users')
            .update({'avatar_url': path})
            .eq('id', _uid)
            .select('id, display_name, email, avatar_url, phone, timezone')
            .single();

        if (old != null && !old.startsWith('http')) {
          try {
            await _client.storage.from(_bucket).remove([old]);
          } on StorageException {
            /* leave the orphan */
          }
        }
        return _profile(row);
      });

  @override
  Future<void> syncTimezone() async {
    try {
      final tz = await FlutterTimezone.getLocalTimezone();
      await _client.from('users').update({'timezone': tz}).eq('id', _uid);
    } catch (_) {/* best-effort */}
  }
}
