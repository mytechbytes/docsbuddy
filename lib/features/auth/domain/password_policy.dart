/// Pure password-strength score for the change-password meter.
/// 0 = empty · 1 Weak · 2 Fair · 3 Good · 4 Excellent.
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
