import 'dart:math' as Math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ls_netchat_plugin/lsnetchatplugin.dart';
import 'package:ls_netchat_plugin/message_data.dart';

import '../env/env.dart';

class Pocket48DanmakuNotifier extends StateNotifier<List<NIMessage>> {
  int roomId;
  int maxMessageHoldCount = 200;
  List<NIMessage> _messageList = [];

  Pocket48DanmakuNotifier({required this.roomId}) : super([]) {
    _initLive();
  }

  //初始化
  void _initLive() {
    try {
      _joinRoom();
    } catch (e) {
      print("LiveChat Enter Error: $e");
    }
  }

  void _joinRoom() {
    Lsnetchatplugin.enterRoomWithOutLogin(roomId.toString(), Env.nimLinkAddr)
        .then((data) {
      //print(data);
    });
    //回调类型：List<NIMessage>
    Lsnetchatplugin.addListener(roomId.toString(), (messages) {
      _messageList.addAll(messages);
      if (_messageList.length > maxMessageHoldCount) {
        _messageList.removeRange(0, _messageList.length - maxMessageHoldCount);
      }
      _addMessages(List.from(
          _messageList.sublist(Math.max(0, _messageList.length - 50))));
    });
  }

  void _addMessages(List<NIMessage> data) {
    state = data;
  }

  @override
  void dispose() {
    Lsnetchatplugin.removeListener(roomId.toString());
    Lsnetchatplugin.exitChatRoom(roomId.toString());
    super.dispose();
  }
}
