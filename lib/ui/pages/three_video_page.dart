import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sibatv/model/live.dart';

import '../widget/dammu_video_view.dart';
import '../widget/live_list_widget.dart';
import 'chat48_page.dart';

class ThreeVideoPage extends StatefulWidget {
  final String liveId;
  final bool liveMode;
  ThreeVideoPage({required this.liveId, required this.liveMode});

  @override
  _ThreeVideoPageState createState() => _ThreeVideoPageState();
}

class _ThreeVideoPageState extends State<ThreeVideoPage> {
  final Live _live = Live(inLive: false);

  String _url = "";
  String title = "";
  String roomId = "";
  String msgFilePath = "";
  @override
  void initState() {
    super.initState();

    _live.requestLiveRoomInfo(widget.liveId).then((liveRoomInfo) {
      title = liveRoomInfo.content.user.userName;
      roomId = liveRoomInfo.content.roomId;
      msgFilePath = liveRoomInfo.content.msgFilePath ?? "";
      return liveRoomInfo.content.playStreamPath;
    }).catchError((error) {
      //Response body: {"status":1012,"success":false,"message":"回放生成中"}
      throw Exception('Something occurred.');
    }).then((String url) {
      _updateUrl(url);
    });
  }

  void _updateUrl(url) {
    setState(() {
      _url = url;
      //_url = 'asset:///assets/akb48.mp4';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_url == "") {
      return Container(color: Colors.black87);
    } else {
      return Scaffold(
          primary: true,
          backgroundColor: Colors.black54,
          body: Container(
              color: Colors.black87,
              child: CustomVideoPlayer(
                  liveId: widget.liveId,
                  url: _url,
                  title: title,
                  roomId: roomId,
                  msgFilePath: msgFilePath,
                  liveMode: widget.liveMode)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// 自定义播放器
class CustomVideoPlayer extends StatefulWidget {
  final String url; //播放连接
  final String title; //播放连接
  final String roomId;
  final bool showCover; // 显示第一帧封面
  final bool autoPlay; //自动播放
  final Widget? barrageUI;
  final bool liveMode;
  final String liveId;
  final String msgFilePath;

  const CustomVideoPlayer(
      {Key? key,
      required this.liveId,
      required this.url,
      required this.roomId,
      required this.title,
      required this.liveMode,
      required this.msgFilePath,
      this.showCover = true,
      this.autoPlay = true,
      this.barrageUI})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

/// RouteAware 监听当前页面的生命周期
/// WidgetsBindingObserver 前后台
class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with RouteAware, WidgetsBindingObserver {
  //是否在前台
  bool isResume = true;
  late List<String> urls;
  late List<String> titles;
  late List<String> roomIds;
  late List<String> msgFilePaths;
  late List<UniqueKey> keys;
  late List<LiveListController> listControllers;
  PlayerShowConfig _playerShowConfig = PlayerShowConfig();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    urls = ["", widget.url, ""];
    titles = ["", widget.title, ""];
    roomIds = ["", widget.roomId, ""];
    msgFilePaths = ["", widget.msgFilePath, ""];
    keys = [UniqueKey(), UniqueKey(), UniqueKey()];
    listControllers = [
      LiveListController(),
      LiveListController(),
      LiveListController()
    ];
    _playerShowConfig.bottomSlideBar = true;
    _playerShowConfig.fullScreenBtn = true;
    //TODO
    //player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);

    //players[1].setVolume(1);
    // 这句不能省，必须有
    //speed = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    //设置播放器宽高
    //double playerWidth = SizeConfig.safeBlockHorizontal! * 33;
    //double playerHeight = playerWidth * (9 / 16);
    return Row(children: [
      Expanded(
        child: _buildPlayerOrLiveList(0),
      ),
      Expanded(
        child: _buildPlayerOrLiveList(1),
      ),
      Expanded(
        child: _buildPlayerOrLiveList(2),
      )
    ]);
  }

  Widget _buildPlayerOrLiveList(int no) {
    if (urls[no].isEmpty) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LiveListWidget(
          liveMode: widget.liveMode,
          imageClick: (liveId) => _clickSideLive(no, liveId),
        ),
        LiveListWidget(
          liveMode: !widget.liveMode,
          imageClick: (liveId) => _clickSideLive(no, liveId),
        )
      ]);
    } else {
      /*
      return DanmuVideoView(
      */
      return Chat48Page(
        key: keys[no],
        url: urls[no],
        title: titles[no],
        reloadClick: () => _clickSideLive(no, widget.liveId),
        barrageUI: Container(),
        roomId: roomIds[no],
        msgFilePath: msgFilePaths[no],
        listViewController: listControllers[no],
        listViewUI: LiveListWidget(
          controller: listControllers[no],
          liveMode: widget.liveMode,
          imageClick: (liveId) => _clickSideLive(no, liveId),
        ),
        onCloseClick: (context) => _closeClick(no, context),
        showConfig: _playerShowConfig,
      );
    }
  }

  void _clickSideLive(int no, String liveId) {
    final Live live = Live(inLive: false);

    live.requestLiveRoomInfo(liveId).then((liveRoomInfo) {
      setState(() {
        titles[no] = liveRoomInfo.content.user.userName;
        urls[no] = liveRoomInfo.content.playStreamPath;
        roomIds[no] = liveRoomInfo.content.roomId;
        msgFilePaths[no] = liveRoomInfo.content.msgFilePath ?? "";
        keys[no] = UniqueKey();
      });
    }).catchError((error) {
      throw Exception('Something occurred.');
    });
  }

  void _closeClick(int no, BuildContext? context) {
    setState(() {
      urls[no] = "";
      keys[no] = UniqueKey();
      roomIds[no] = "";
      titles[no] = "";
      msgFilePaths[no] = "";
    });
    if (!urls.any((e) => e.isNotEmpty)) {
      //All Element empty
      if (context == null) return;
      Navigator.pop(context);
    }
  }

  /// 监听app 前后台
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 可见时执行
    if (isResume == false) {
      return;
    }
  }

  /// 下一个界面进入
  @override
  void didPushNext() {
    super.didPushNext();
    isResume = false;
  }

  /// 下一个界面退出
  @override
  void didPopNext() {
    super.didPopNext();
    isResume = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //routeObserver.unsubscribe(this);
    super.dispose();
  }
}
