import '../../../core/error/app_failure.dart';

/// Pure: normalizes a phone input to E.164 (`+919812345678`) — strips
/// spaces/dashes/dots/parens — or returns null when it can't be a valid
/// international number. WhatsApp delivery requires this format.
String? normalizePhone(String input) {
  final cleaned = input.trim().replaceAll(RegExp(r'[\s\-().]'), '');
  if (cleaned.isEmpty) return null;
  return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(cleaned) ? cleaned : null;
}

/// Profile-form rule: blank clears the number; otherwise it must normalise.
/// Returns the value to store ('' = clear) or throws [ValidationFailure].
String validatePhoneInput(String input) {
  if (input.trim().isEmpty) return '';
  return normalizePhone(input) ??
      (throw const ValidationFailure('Use the international format, e.g. +91 9812345678.', reason: FailureReason.phoneFormat));
}
