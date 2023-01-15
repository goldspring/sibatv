import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sibatv/repository/bilibili_danmaku_notifier.dart';

final BiliBiliDanmakuProvider = StateNotifierProvider.autoDispose
    .family<BiliBiliDanmakuNotifier, List<dynamic>, int>((ref, roomId) {
  return BiliBiliDanmakuNotifier(roomId: roomId);
});

final BiliBiliDanmakuStreamProvider =
    StreamProvider.autoDispose.family<List<dynamic>, int>((ref, roomId) {
  final dynamic stream = ref.watch(BiliBiliDanmakuProvider(roomId));
  return Stream.value(stream);
});
