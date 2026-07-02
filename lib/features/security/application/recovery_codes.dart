import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Unambiguous alphabet (no 0/O/1/I) for hand-typed recovery codes.
const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

/// Generates [count] recovery codes shaped like `K7QF-3MRD`.
List<String> generateRecoveryCodes({int count = 10, Random? random}) {
  final rng = random ?? Random.secure();
  String block() => List.generate(4, (_) => _alphabet[rng.nextInt(_alphabet.length)]).join();
  return List.generate(count, (_) => '${block()}-${block()}');
}

/// SHA-256 of a normalized code — only hashes are persisted.
String hashRecoveryCode(String code) =>
    sha256.convert(utf8.encode(code.trim().toUpperCase())).toString();
