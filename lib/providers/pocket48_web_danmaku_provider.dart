/*
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/pocket48_web_danmaku_notifier.dart';

final Pocket48WebDanmakuProvider = StateNotifierProvider.autoDispose
    .family<Pocket48WebDanmakuNotifier, List<dynamic>, int>((ref, roomId) {
  return Pocket48WebDanmakuNotifier(roomId: roomId);
});

final Pocket48WebDanmakuStreamProvider =
    StreamProvider.autoDispose.family<List<dynamic>, int>((ref, roomId) {
  final dynamic stream = ref.watch(Pocket48WebDanmakuProvider(roomId));
  return Stream.value(stream);
});
*/
