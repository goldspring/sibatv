import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sibatv/model/live_info.dart';
import 'package:sibatv/repository/lives_notifier.dart';

import '../utils/bilibili_live_api.dart';

final pocket48LiveProvider =
    StateNotifierProvider.family<LivesNotifier, List<LiveData>, bool>(
        (ref, inLive) {
  return (inLive)
      ? LivesNotifier(inLive: inLive)
      : LivesNotifier(inLive: inLive);

  // disposeはいるか？
});

final pocket48LiveStreamProvider =
    StreamProvider.family<List<LiveData>, bool>((ref, inLive) {
  final List<LiveData> stream = ref.watch(pocket48LiveProvider(inLive));
  return Stream.value(stream);
});

final biliLiveUrlsProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, roomId) async {
  // disposeはいるか？
  return LiveApi.getLiveOrLunbo(roomId);
});

final biliLiveInfoProvider = FutureProvider.autoDispose
    .family<BiliLiveInfo?, String>((ref, roomId) async {
  // disposeはいるか？
  return LiveApi.getLiveInfo(roomId);
});
final bilibiliRoomStateStreamProvider =
    StreamProvider.autoDispose.family<BiliLiveInfo?, String>((ref, roomId) {
  return LiveApi.getLiveInfo(roomId).asStream();
});
