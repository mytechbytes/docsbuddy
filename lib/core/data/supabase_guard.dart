import 'package:supabase_flutter/supabase_flutter.dart';

import '../error/app_failure.dart';

/// Runs a backend call and translates Supabase/transport exceptions into
/// [AppFailure]s, so nothing SDK-specific leaks past the data layer.
Future<T> guardBackend<T>(Future<T> Function() run) async {
  try {
    return await run();
  } on AppFailure {
    rethrow;
  } on AuthException catch (e) {
    throw AuthFailure(e.message);
  } on PostgrestException catch (e) {
    throw ServerFailure(e.message);
  } on StorageException catch (e) {
    throw ServerFailure(e.message);
  } catch (e) {
    if (isNetworkError(e)) throw const NetworkFailure();
    throw UnknownFailure(e);
  }
}

/// Heuristic for socket/DNS/HTTP-client failures, which surface as several
/// unrelated exception types depending on platform.
bool isNetworkError(Object e) {
  final s = e.toString();
  return s.contains('SocketException') ||
      s.contains('Failed host lookup') ||
      s.contains('ClientException') ||
      s.contains('Connection');
}
