/*
import 'dart:math' as Math;
import 'dart:ui';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Pocket48WebDanmakuNotifier extends StateNotifier<List<dynamic>> {
  int roomId;
  late HeadlessInAppWebView headlessWebView;
  //List _messageList = [];

  Pocket48WebDanmakuNotifier({required this.roomId}) : super([]) {
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
    headlessWebView = HeadlessInAppWebView(
        initialFile: "lib/js/index.html",
        initialSize: const Size(1, 1),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
              handlerName: 'setMessagesView',
              callback: (args) async {
                _msgView(args);
                // return data to the JavaScript side!
                return;
              });
        },

        //onConsoleMessage: (controller, consoleMessage) {
        //  print("================" +
        //      consoleMessage.toString() +
        //      "====================");
        //},

        onLoadStart: (controller, url) async {},
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(
              source: "init('" + this.roomId.toString() + "');");
        });
    headlessWebView.run();
  }

  void _msgView(dynamic args) async {
    List<dynamic> allMsgs = args[0];
    _addMessages(List.from(allMsgs.sublist(Math.max(0, allMsgs.length - 50))));
  }

  void _addMessages(List<dynamic> data) {
    state = data;
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView.dispose();
  }
}
*/
