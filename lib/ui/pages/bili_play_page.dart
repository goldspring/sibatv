import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/live_provider.dart';
import '../../providers/tab_provider.dart';
import '../../utils/bilibili_live_api.dart';
import '../widget/dammu_video_view.dart';
import '../widget/danmaku/bilibili_danmaku_layer.dart';
//import '../widget/danmaku/bilibili_danmaku_layer.dart';

class BilibiliPlayPage extends ConsumerStatefulWidget {
  final String roomId;
  final String cover;
  final String userName;
  final int tabNo;
  BilibiliPlayPage(this.tabNo, this.roomId,
      {required this.cover, required this.userName});
  @override
  _BilibiliPlayPageState createState() => _BilibiliPlayPageState();
}

class _BilibiliPlayPageState extends ConsumerState<BilibiliPlayPage>
    with AutomaticKeepAliveClientMixin {
  int index = 0;
  VideoStateController _videoStateController = VideoStateController();
  DanmuVideoController _videoController = DanmuVideoController();
  PlayerShowConfig _playerShowConfig = PlayerShowConfig();
  bool isLive = false;
  @override
  void initState() {
    super.initState();
    _playerShowConfig.fullScreenBtn = true;
    _playerShowConfig.topCloseBtn = false;
    _playerShowConfig.bottomSlideBar = true;
    // _initLive();
    _reloadRoom();
    _videoStateController.addListener(() {
      if (_videoStateController.PlayerState == FijkState.completed) {
        if (!isLive) {
          //lunbo
          _reloadRoom();
          _autoPlay = true;
          //_videoController.requestStateChage(
//              play: true, fullScreen: _videoStateController.FullScreen);
          _fullScreen = _videoStateController.FullScreen;
        }
      } else {
        _autoPlay = false;
        _fullScreen = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _playing = false;
  void _playStateChange(bool playing) {
    setState(() {
      _playing = playing;
    });
  }

  bool _autoPlay = false;
  bool _fullScreen = false;
  @override
  Widget build(BuildContext context) {
    AsyncValue<BiliLiveInfo?> info =
        ref.watch(biliLiveInfoProvider(widget.roomId));
    return Scaffold(
        primary: true,
        backgroundColor: Colors.black54,
        body: Container(
            color: Colors.black87,
            child: info.when(
                data: (liveInfo) {
                  if (liveInfo != null) {
                    isLive = (liveInfo.liveStatus == 1);
                  } else {
                    isLive = false;
                  }
                  return (liveInfo != null)
                      ? buildLiveView(liveInfo)
                      : buildEmptyView();
                },
                error: (e, s) {
                  isLive = false;
                  print("info error");
                  print(e);
                  print(s);
                  buildErrorView();
                },
                loading: () => buildLoadingView())));
  }

  Widget buildLoadingView() {
    isLive = false;
    return FractionallySizedBox(
      widthFactor: 1, //0.6倍
      heightFactor: 1, //0.85倍
      child: Container(child: Image.asset("images/ic_loading.png")),
    );
  }

  Widget buildErrorView() {
    return FractionallySizedBox(
      widthFactor: 1, //0.6倍
      heightFactor: 1, //0.85倍
      child: Container(child: Image.asset("images/ic_loading_error.png")),
    );
  }

  Widget buildEmptyView() {
    return FractionallySizedBox(
      widthFactor: 1, //0.6倍
      heightFactor: 1, //0.85倍
      child: Container(child: Image.asset("images/ic_empty.png")),
    );
  }

  Widget buildLiveView(BiliLiveInfo info) {
    final tabNo = ref.read(tabPageProvider);
    if (tabNo != widget.tabNo) {
      _videoController.requestStateChage(play: false);
    } else {
      // _videoController.requestStateChage(play: true);
    }

    if (info.isPortrait) {
      return Container();
    }
    AsyncValue<List<String>> urls =
        ref.watch(biliLiveUrlsProvider(widget.roomId));
    return urls.when(
        data: (data) {
          var full = false;
          var auto = false;
          var url = "";
          if (data.isEmpty || data[0] == "") {
            return buildEmptyView();
          } else {
            setState(() {
              url = data[0];
            });
            auto = _autoPlay;
            full = _fullScreen;
          }
          return FractionallySizedBox(
              widthFactor: 1, //1倍
              heightFactor: 1, //1倍
              child: DanmuVideoView(
                fullscreen: full,
                videoStateController: _videoStateController,
                controller: _videoController,
                onPlayStateChange: _playStateChange,
                url: url,
                title: widget.userName,
                autoPlay: auto,
                reloadClick: _reloadRoom,
                barrageUI: _playing
                    ? BiliBiliDanmakuLayer(
                        int.parse(widget.roomId), _videoController)
                    // BiliBiliChatLayer(
                    //    int.parse(widget.roomId), _videoController)
                    : Container(),
                showConfig: _playerShowConfig,
              ));
        },
        error: (e, s) {
          print("url error");
          print(e);
          print(s);
          return buildErrorView();
        },
        loading: () => buildLoadingView());
  }

  void _reloadRoom() {
    ref.refresh(biliLiveInfoProvider(widget.roomId));
    ref.refresh(biliLiveUrlsProvider(widget.roomId));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
