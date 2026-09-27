import '../../../core/error/app_failure.dart';

/// Which password requirements [password] meets (reset/sign-up checklists).
typedef PasswordChecks = ({bool length, bool upper, bool number, bool special});

PasswordChecks checkPassword(String password) => (
      length: password.length >= 8,
      upper: RegExp(r'[A-Z]').hasMatch(password),
      number: RegExp(r'[0-9]').hasMatch(password),
      special: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
    );

/// Sign-up meter: 0–4 (one point per met check) with a hint.
(int score, String hint) signUpStrength(String password) {
  if (password.isEmpty) return (0, _hints[0]);
  final c = checkPassword(password);
  final score = [c.length, c.upper, c.number, c.special].where((ok) => ok).length;
  return (score, _hints[score]);
}

const _hints = [
  'Use 8+ chars with a number and symbol.',
  'Use 8+ chars with a number and symbol.',
  'Fair — add an uppercase letter or symbol.',
  'Strong — keep going for excellent.',
  'Excellent password.',
];

/// Change-password meter: 0 = empty · 1 Weak · 2 Fair · 3 Good · 4 Excellent.
(int score, String label) passwordStrength(String password) {
  if (password.isEmpty) return (0, '');
  var classes = 0;
  if (password.contains(RegExp(r'[a-z]'))) classes++;
  if (password.contains(RegExp(r'[A-Z]'))) classes++;
  if (password.contains(RegExp(r'[0-9]'))) classes++;
  if (password.contains(RegExp(r'[^A-Za-z0-9]'))) classes++;

  var score = 1;
  if (password.length >= 8 && classes >= 2) score = 2;
  if (password.length >= 10 && classes >= 3) score = 3;
  if (password.length >= 12 && classes >= 4) score = 4;

  return (
    score,
    switch (score) {
      1 => 'Weak',
      2 => 'Fair',
      3 => 'Good',
      _ => 'Excellent',
    }
  );
}

/// Throws [ValidationFailure] unless [password] meets the reset rules
/// (8+ chars, an uppercase letter, a number) and matches [confirmation].
void validateResetPassword(String password, String confirmation) {
  final c = checkPassword(password);
  if (!(c.length && c.upper && c.number)) throw const ValidationFailure('Please meet the password requirements.', reason: FailureReason.passwordRequirements);
  if (password != confirmation) throw const ValidationFailure('Passwords do not match.', reason: FailureReason.passwordMismatch);
}

/// Throws [ValidationFailure] unless the change-password inputs are usable.
void validateNewPassword(String password, String confirmation) {
  if (password.length < 8) throw const ValidationFailure('New password must be at least 8 characters.', reason: FailureReason.newPasswordTooShort);
  if (password != confirmation) throw const ValidationFailure('Passwords don\'t match.', reason: FailureReason.passwordMismatch);
}
