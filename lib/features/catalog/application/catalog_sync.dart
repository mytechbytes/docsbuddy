import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/push/push_messaging_service.dart';
import 'catalog_providers.dart';

/// Refreshes catalog reads when a silent push says another family member
/// changed something. Watch it from the signed-in shell to activate.
final remoteChangeSyncProvider = Provider<void>((ref) {
  final sub = ref.watch(pushMessagingServiceProvider).remoteChanges.listen((_) {
    ref.read(catalogRefresherProvider).all();
  });
  ref.onDispose(sub.cancel);
});
