import 'dart:async';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sibatv/ui/widget/player/video_control_panel.dart';

import 'live_list_widget.dart';

class DanmuVideoView extends StatefulWidget {
  final DanmuVideoController? controller;
  final PlayerPosStreamSubscriver? posSubscriver;
  final VideoStateController? videoStateController;
  final String url; //播放连接
  final String title; //播放连接
  final bool showCover; // 显示第一帧封面
  final bool autoPlay; //自动播放
  final PlayerShowConfig showConfig;
  final Widget? barrageUI;
  final Widget? listViewUI;
  final void Function(bool)? onPlayStateChange;
  final void Function(BuildContext?)? onCloseClick;
  final void Function() reloadClick;
  final LiveListController? listViewController;
  final bool fullscreen;
  const DanmuVideoView({
    Key? key,
    required this.url,
    required this.title,
    required this.reloadClick,
    required this.showConfig,
    this.fullscreen = false,
    this.videoStateController = null,
    this.posSubscriver = null,
    this.controller = null,
    this.showCover = true,
    this.autoPlay = true,
    this.barrageUI,
    this.listViewController,
    this.listViewUI,
    this.onPlayStateChange,
    this.onCloseClick,
  }) : super(key: key);

  @override
  State<DanmuVideoView> createState() => _DanmuVideoViewSate();
}

/// RouteAware 监听当前页面的生命周期
/// WidgetsBindingObserver 前后台
class _DanmuVideoViewSate extends State<DanmuVideoView>
    with RouteAware, WidgetsBindingObserver {
  // FijkPlayer实例
  FijkPlayer player = FijkPlayer();
  final PlayerShowConfig showConfig = PlayerShowConfig();

  //是否在前台
  bool isResume = true;
  StreamSubscription<Duration>? streamSubscription;
  @override
  void initState() {
    super.initState();
    widget.posSubscriver?.currentPos = player.currentPos;
    streamSubscription = player.onCurrentPosUpdate.listen((d) {
      widget.posSubscriver?.currentPos = d;
      widget.posSubscriver?.currentPosUpdate();
    });

    showConfig.speedBtn = widget.showConfig.speedBtn;
    showConfig.lockBtn = widget.showConfig.lockBtn;
    showConfig.topBar = widget.showConfig.topBar;
    showConfig.bottomPro = widget.showConfig.bottomPro;
    showConfig.stateAuto = widget.showConfig.stateAuto;
    showConfig.isAutoPlay = widget.showConfig.isAutoPlay;
    showConfig.fullScreenBtn = widget.showConfig.fullScreenBtn;
    showConfig.bottomPlayStateBtn = widget.showConfig.bottomPlayStateBtn;
    showConfig.topBackBtn = widget.showConfig.topBackBtn;
    showConfig.topCloseBtn = widget.showConfig.topCloseBtn;
    showConfig.bottomSlideBar = widget.showConfig.bottomSlideBar;
    showConfig.showListViewUI = widget.showConfig.showListViewUI;
    WidgetsBinding.instance.addObserver(this);
    player.setOption(
        FijkOption.formatCategory, "headers", "User-Agent:SNH48 ENGINE");
    player.setDataSource(
      widget.url,
      autoPlay: widget.autoPlay,
      showCover: widget.showCover,
    );

    player.setOption(FijkOption.playerCategory, "framedrop", 20);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-avc", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-hevc", 1);
    player.setOption(FijkOption.playerCategory, "fast", 1);
    player.setOption(FijkOption.playerCategory, "opensles", 1);
    //player.setOption(FijkOption.playerCategory, "infbuf", 1);
    player.setOption(FijkOption.playerCategory, "reconnect", 3);
    player.setOption(FijkOption.formatCategory, "formatprobesize", 4096);
    player.setOption(FijkOption.formatCategory, "reconnect", 1);

    //TODO
    //player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    //players[1].setVolume(1);
    speed = 1.0;
    player.setSpeed(speed);
    player.addListener(_playerValueChanged);

    widget.controller?.addListener(() {
      bool request = widget.controller!.requestPlay;
      if (request) {
        player.start();
      } else {
        if (player.state == FijkState.started) {
          player.pause();
        }
      }
    });
    if (widget.fullscreen) {
      player.addListener(_cnagefs);
    }
  }

  void _cnagefs() {
    player.enterFullScreen();
    player.removeListener(_cnagefs);
  }

  bool? _playing = null;

  bool? _fullScreen = null;
  void _playerValueChanged() {
    FijkValue value = player.value;
    bool playing = (value.state == FijkState.started);

    if (_playing != playing) {
      if (widget.onPlayStateChange != null) {
        widget.onPlayStateChange!(playing);
      }
      _playing = playing;
      var f = value.fullScreen;
      if (player.state == FijkState.completed) {
        player.exitFullScreen();
      }
      widget.videoStateController?.playerStateChanged(value.state, f);
    }
    if (_fullScreen != value.fullScreen) {
      if (_fullScreen != null) {
        player.pause().whenComplete(() {
          if (_playing != null && _playing!) player.start();
        });
      }
      _fullScreen = value.fullScreen;
    }
    if (value.size != null) {
      print("height: ${value.size!.height}");
      if (value.size!.height < value.size!.width) {
        setState(() {
          showConfig.showListViewUI = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //设置播放器宽高
    //double playerWidth = SizeConfig.safeBlockHorizontal! * 33;
    //double playerHeight = playerWidth * (9 / 16);
    return FijkView(
      player: player,
      color: Colors.black,
      // 自定义面板
      panelBuilder: (FijkPlayer player, FijkData data, BuildContext context,
          Size viewSize, Rect texturePos) {
        return Stack(
          children: [
            //弹幕组件
            //控制组件
            if (widget.barrageUI != null) widget.barrageUI!,
            _customPanel(widget.title, player, viewSize, texturePos, context,
                (context) => _closeClick(context)),
          ],
        );
      },
    );
  }

  /// 自定义控制面板
  Widget _customPanel(
    String title,
    FijkPlayer player,
    Size viewSize,
    Rect texturePos,
    BuildContext? pageContext,
    void Function(BuildContext? context)? closeClick,
  ) {
    return VideoControlPanel(
      controller: widget.controller,
      player: player,
      // 传递 context 用于左上角返回箭头关闭当前页面，不要传递错误 context，
      // 如果要点击箭头关闭当前的页面，那必须传递当前组件的根 context
      pageContext: pageContext,
      viewSize: viewSize,
      texturePos: texturePos,
      // 标题 当前页面顶部的标题部分，可以不传，默认空字符串
      playerTitle: title,
      // 显示的配置
      showConfig: showConfig,
      closeClick: closeClick,
      listViewController: widget.listViewController,
      listViewUI: widget.listViewUI,
      reloadClick: widget.reloadClick,
    );
  }

  void _closeClick(BuildContext? context) {
    player.stop().whenComplete(() {
      player.reset();
    });
    setState(() {
      //  url = "";
    });
    if (widget.onCloseClick != null) widget.onCloseClick!(context);
    /*
    if (!urls.any((e) => e.isNotEmpty)) {
      //All Element empty
      if (context == null) return;
      Navigator.pop(context);
    }
     */
  }

  /// 监听app 前后台
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 可见时执行
    if (isResume == false) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      player.start();
      player.pause();
    }
  }

  /// 下一个界面进入
  @override
  void didPushNext() {
    super.didPushNext();
    isResume = false;
    player.pause();
  }

  /// 下一个界面退出
  @override
  void didPopNext() {
    super.didPopNext();
    isResume = true;
    player.start();
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
    player.removeListener(_playerValueChanged);
    player.reset().whenComplete(() => player.dispose());
    super.dispose();
  }
}

// 这里实现一个皮肤显示配置项
class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool speedBtn = false; // 是否显示速度按钮
  @override
  bool topBar = true; // 是否显示播放器状态栏（顶部），非系统
  @override
  bool lockBtn = false; // 是否显示锁按钮

  @override
  bool bottomPro = false; // 底部吸底进度条，贴底部，类似开眼视频
  @override
  bool stateAuto = false; // 是否自适应系统状态栏，true 会计算系统状态栏，从而加大 topBar 的高度，避免挡住播放器状态栏
  @override
  bool isAutoPlay = true; // 是否自动开始播放
  @override
  bool fullScreenBtn = false;
  @override
  bool bottomPlayStateBtn = true;
  @override
  bool topBackBtn = false;
  @override
  bool topCloseBtn = true;
  @override
  bool bottomSlideBar = false;
  @override
  bool showListViewUI = true;
}

class DanmuVideoController extends ChangeNotifier {
  bool requestPlay = false;
  void requestStateChage({required bool play}) {
    requestPlay = play;
    notifyListeners();
  }

  bool showBarrage = true;
}

class VideoStateController extends ChangeNotifier {
  FijkState? PlayerState = null;
  bool FullScreen = false;
  void playerStateChanged(FijkState state, bool fullScreen) {
    PlayerState = state;
    FullScreen = fullScreen;
    notifyListeners();
  }
}

class PlayerPosStreamSubscriver {
  Duration currentPos = const Duration();

  void Function(Duration)? onUpdatePos;
  PlayerPosStreamSubscriver();
  void currentPosUpdate() async {
    onUpdatePos?.call(currentPos);
  }
}
