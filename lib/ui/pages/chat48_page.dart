import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sibatv/ui/widget/danmaku/msgfile48_chat_layer.dart';

import '../widget/dammu_video_view.dart';
//import '../widget/danmaku/pocket48_web_chat_layer.dart';
import '../widget/danmaku/pocket48_chat_layer.dart';
import '../widget/live_list_widget.dart';

class Chat48Page extends StatefulWidget {
  final String url; //播放连接
  final String title; //播放连接
  final String roomId;
  final String msgFilePath;
  final PlayerShowConfig showConfig;
  final Widget? barrageUI;
  final Widget? listViewUI;
  final void Function(BuildContext?)? onCloseClick;
  final void Function() reloadClick;
  final LiveListController? listViewController;
  const Chat48Page({
    Key? key,
    required this.url,
    required this.title,
    required this.roomId,
    required this.reloadClick,
    required this.showConfig,
    required this.msgFilePath,
    this.barrageUI,
    this.listViewController,
    this.listViewUI,
    this.onCloseClick,
  }) : super(key: key);

  @override
  State<Chat48Page> createState() => _Chat48PageSate();
}

/// RouteAware 监听当前页面的生命周期
/// WidgetsBindingObserver 前后台
class _Chat48PageSate extends State<Chat48Page>
    with RouteAware, WidgetsBindingObserver {
  DanmuVideoController _videoController = DanmuVideoController();
  PlayerPosStreamSubscriver posStreamSubscriver = PlayerPosStreamSubscriver();
  bool initFlg = false;
  void update() {
    setState(() {
      initFlg = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DanmuVideoView(
      key: widget.key,
      controller: _videoController,
      posSubscriver: posStreamSubscriver,
      url: widget.url,
      title: widget.title,
      autoPlay: true,
      reloadClick: widget.reloadClick,
      listViewController: widget.listViewController,
      listViewUI: widget.listViewUI,
      barrageUI: widget.roomId != "0"
          ? Pocket48ChatLayer(int.parse(widget.roomId),
              _videoController) //Pocket48WebChatLayer(int.parse(widget.roomId),_videoController)
          : MsgFile48ChatLayer(
              widget.msgFilePath, posStreamSubscriver, _videoController),
      onCloseClick: widget.onCloseClick,
      showConfig: widget.showConfig,
    );
  }
}
