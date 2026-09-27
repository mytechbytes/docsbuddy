/// Pure: normalizes a phone input to E.164 (`+919812345678`) — strips
/// spaces/dashes/dots/parens — or returns null when it can't be a valid
/// international number. WhatsApp delivery requires this format.
String? normalizePhone(String input) {
  final cleaned = input.trim().replaceAll(RegExp(r'[\s\-().]'), '');
  if (cleaned.isEmpty) return null;
  return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(cleaned) ? cleaned : null;
}
