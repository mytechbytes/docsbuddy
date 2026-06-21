import 'dart:async';

import 'auth_repository.dart';

/// In-memory auth used when no Supabase credentials are configured (local dev,
/// tests, and the CI-built APK). Simulates latency and basic validation so the
/// screens exercise their real loading/error/success paths.
class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<bool>.broadcast();
  bool _signedIn = false;

  static final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  Future<void> _delay() => Future<void>.delayed(const Duration(milliseconds: 700));

  void _setSignedIn(bool value) {
    _signedIn = value;
    _controller.add(value);
  }

  @override
  Stream<bool> authStateChanges() => _controller.stream;

  @override
  bool get isSignedIn => _signedIn;

  @override
  Future<void> signInWithPassword({required String email, required String password}) async {
    await _delay();
    if (!_emailRe.hasMatch(email)) throw const AuthFailure('Enter a valid email address.');
    if (password.length < 6) throw const AuthFailure('Incorrect email or password.');
    _setSignedIn(true);
  }

  @override
  Future<void> signUp({required String name, required String email, required String password}) async {
    await _delay();
    if (name.trim().isEmpty) throw const AuthFailure('Please enter your name.');
    if (!_emailRe.hasMatch(email)) throw const AuthFailure('Enter a valid email address.');
    if (password.length < 8) throw const AuthFailure('Password must be at least 8 characters.');
    _setSignedIn(true);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _delay();
    _setSignedIn(true);
  }

  @override
  Future<void> signInWithApple() async {
    await _delay();
    _setSignedIn(true);
  }

  @override
  Future<void> sendPasswordResetCode(String email) async {
    await _delay();
    if (!_emailRe.hasMatch(email)) throw const AuthFailure('Enter a valid email address.');
  }

  @override
  Future<void> verifyResetCode({required String email, required String token}) async {
    await _delay();
    if (token.length != 6) throw const AuthFailure('Enter the 6-digit code.');
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await _delay();
    if (newPassword.length < 8) throw const AuthFailure('Password must be at least 8 characters.');
  }

  @override
  Future<void> signOut() async {
    await _delay();
    _setSignedIn(false);
  }
}
