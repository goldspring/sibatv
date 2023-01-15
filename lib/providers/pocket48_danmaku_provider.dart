import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ls_netchat_plugin/login_data.dart';
import 'package:ls_netchat_plugin/lsnetchatplugin.dart';
import 'package:ls_netchat_plugin/message_data.dart';

import '../repository/pocket48_danmaku_notifier.dart';

final Pocket48DanmakuProvider = StateNotifierProvider.autoDispose
    .family<Pocket48DanmakuNotifier, List<NIMessage>, int>((ref, roomId) {
  return Pocket48DanmakuNotifier(roomId: roomId);
});

final Pocket48DanmakuStreamProvider =
    StreamProvider.autoDispose.family<List<NIMessage>, int>((ref, roomId) {
  final dynamic stream = ref.watch(Pocket48DanmakuProvider(roomId));
  return Stream.value(stream);
});

final Pocket48RoomInfoStateStreamProvider =
    StreamProvider.autoDispose.family<ChatRoomInfoData, String>((ref, roomId) {
  return Lsnetchatplugin.getRoomInfo(roomId.toString()).asStream();
});
