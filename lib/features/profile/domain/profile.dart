import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

/// The signed-in user's profile — `public.users` plus auth-side facts.
@freezed
abstract class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    required String id,
    required String displayName,
    required String email,

    /// Bucket path or absolute URL — render via the shared image resolver.
    String? avatarUrl,

    /// E.164 — also the WhatsApp reminder destination.
    String? phone,
    String? timezone,
    @Default(false) bool verified,
  }) = _Profile;

  String get initial => initialOf(displayName);
}

/// First-letter avatar fallback.
String initialOf(String name) => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

/// Every method throws an `AppFailure` on error.
abstract interface class ProfileRepository {
  Future<Profile> get();

  /// Blank [displayName] keeps the current one; blank [phone] clears it.
  Future<Profile> update({String? displayName, String? phone});
  Future<Profile> setAvatar({required Uint8List bytes, required String fileName, required String mimeType});

  /// Stores the device timezone (used by server-side notification
  /// scheduling). Best-effort; never throws.
  Future<void> syncTimezone();
}
