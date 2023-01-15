import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hh_screen_recorder/hh_screen_recorder.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sibatv/providers/tab_provider.dart';
import 'package:sibatv/ui/widget/tv_widget.dart';
import 'package:sibatv/utils/size_config.dart';
import 'package:wakelock/wakelock.dart';

import '../dammu_video_view.dart';
import '../live_list_widget.dart';
//import 'slider.dart' show NewFijkSliderColors, NewFijkSlider;
import 'video_slider.dart';

double speed = 1.0;
bool lockStuff = false;
bool hideLockStuff = false;
bool disableVerDrag = true;
double topBarHeight = SizeConfig.blockSizeVertical! * 10;
double bottomBarHeight = SizeConfig.blockSizeVertical! * 42;
double bottomLineHeight = SizeConfig.blockSizeVertical! * 10;
//double barHeight = ;
final double barFillingHeight =
    MediaQueryData.fromWindow(window).padding.top + topBarHeight;
final double barGap = barFillingHeight - topBarHeight;

abstract class ShowConfigAbs {
  late bool speedBtn;
  late bool lockBtn;
  late bool topBar;
  late bool bottomPro;
  late bool stateAuto;
  late bool isAutoPlay;
  late bool fullScreenBtn;
  late bool bottomPlayStateBtn;
  late bool topBackBtn;
  late bool topCloseBtn;
  late bool bottomSlideBar;
  late bool showListViewUI;
}

class WithPlayerChangeSource {}

/// 格式化时间
String _duration2String(Duration duration) {
  if (duration.inMilliseconds < 0) return "-: negative";

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  int inHours = duration.inHours;
  return inHours > 0
      ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
      : "$twoDigitMinutes:$twoDigitSeconds";
}

/// 自定义面板
class VideoControlPanel extends StatefulWidget {
  final DanmuVideoController? controller;
  final FijkPlayer player;
  final Size viewSize;
  final Rect texturePos;
  final BuildContext? pageContext;
  final String playerTitle;
  final ShowConfigAbs showConfig;
  final Widget? listViewUI;
  final void Function(BuildContext? context)? closeClick;
  final void Function() reloadClick;
  final LiveListController? listViewController;
  const VideoControlPanel({
    Key? key,
    required this.player,
    required this.viewSize, //  对应 FijkView 的实际显示大小
    required this.texturePos, // 视频的实际位置
    required this.showConfig,
    required this.closeClick,
    required this.reloadClick,
    required this.controller,
    this.pageContext,
    this.playerTitle = "",
    this.listViewUI = null,
    this.listViewController,
  }) : super(key: key);

  @override
  VideoControlPanelState createState() => VideoControlPanelState();
}

class VideoControlPanelState extends State<VideoControlPanel>
    with TickerProviderStateMixin /*, AutomaticKeepAliveClientMixin*/ {
  FijkPlayer get player => widget.player;

  ShowConfigAbs get showConfig => widget.showConfig;

  bool _lockStuff = lockStuff;
  bool _hideLockStuff = hideLockStuff;
  Timer? _hideLockTimer;

  FijkState? _playerState;
  bool _isPlaying = false;

  StreamSubscription? _currentPosSubs;

  AnimationController? _animationController;
  void initEvent() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );

    _playerState = player.value.state;
    if (player.value.duration.inMilliseconds > 0 && !_isPlaying) {
      _isPlaying = true;
    }
    setState(() {});
    player.addListener(_onPlayerValueChanged);
    Wakelock.enable();
  }

  @override
  void initState() {
    super.initState();
    initEvent();
  }

  @override
  void dispose() {
    _currentPosSubs?.cancel();
    _hideLockTimer?.cancel();
    player.removeListener(_onPlayerValueChanged);
    _animationController!.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    //全屏尺寸
    Rect rect = player.value.fullScreen
        ? Rect.fromLTWH(
            0,
            0,
            widget.viewSize.width,
            widget.viewSize.height,
          )
        : Rect.fromLTRB(
            max(0.0, widget.texturePos.left),
            max(0.0, widget.texturePos.top),
            min(widget.viewSize.width, widget.texturePos.right),
            min(widget.viewSize.height, widget.texturePos.bottom),
          );
    // 管理组件堆叠
    List<Widget> stackWidgets = [];

    // 错误状态
    if (_playerState == FijkState.error) {
      stackWidgets.add(
        _buildPublicFrameWidget(
          slot: _buildErrorStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    }
    // 准备状态
    else if ((_playerState == FijkState.asyncPreparing ||
            _playerState == FijkState.initialized) &&
        !_isPlaying) {
      stackWidgets.add(
        _buildPublicFrameWidget(
          slot: _buildLoadingStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    }
    // 闲置状态
    else if (_playerState == FijkState.idle && !_isPlaying) {
      stackWidgets.add(
        _buildPublicFrameWidget(
          slot: _buildIdleStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else {
      // 面板锁定
      if (_lockStuff == true &&
          showConfig.lockBtn &&
          widget.player.value.fullScreen) {
        stackWidgets.add(
          _buildLockStateDetector(),
        );
      }
      // 未锁定
      else {
        stackWidgets.add(
          _PanelGestureDetector(
            danmuVideoController: widget.controller,
            player: widget.player,
            texturePos: widget.texturePos,
            showConfig: widget.showConfig,
            pageContext: widget.pageContext,
            playerTitle: widget.playerTitle,
            viewSize: widget.viewSize,
            changeLockState: changeLockState,
            closeClick: widget.closeClick,
            listViewUI: widget.listViewUI,
            listViewController: widget.listViewController,
          ),
        );
      }
    }

    // 返回键
    return WillPopScope(
      child: Positioned.fromRect(
        rect: rect,
        child: Stack(
          children: stackWidgets,
        ),
      ),
      onWillPop: () async {
        if (!widget.player.value.fullScreen) widget.player.stop();
        return true;
      },
    );
  }

  /// 监听播放器变化
  void _onPlayerValueChanged() {
    if (player.value.duration.inMilliseconds > 0 && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    }
    setState(() {
      _playerState = player.value.state;
    });
  }

  // 切换UI lock显示状态
  void changeLockState(bool state) {
    setState(() {
      _lockStuff = state;
      if (state == true) {
        _hideLockStuff = true;
        _cancelAndRestartLockTimer();
      }
    });
  }

  void _cancelAndRestartLockTimer() {
    if (_hideLockStuff == true) {
      _startHideLockTimer();
    }
    setState(() {
      _hideLockStuff = !_hideLockStuff;
    });
  }

  void _startHideLockTimer() {
    _hideLockTimer?.cancel();
    _hideLockTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _hideLockStuff = true;
      });
    });
  }

  // 锁 组件
  Widget _buildLockStateDetector() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _cancelAndRestartLockTimer,
      child: AnimatedOpacity(
        opacity: _hideLockStuff ? 0.0 : 0.7,
        duration: const Duration(milliseconds: 400),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              top:
                  showConfig.stateAuto && !player.value.fullScreen ? barGap : 0,
            ),
            child: IconButton(
              iconSize: 30,
              onPressed: () {
                setState(() {
                  _lockStuff = false;
                  _hideLockStuff = true;
                });
              },
              icon: const Icon(Icons.lock_open),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // 返回按钮
  Widget _buildTopBackBtn() {
    return Container(
      height: topBarHeight,
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Colors.white,
        onPressed: () {
          // 判断当前是否全屏，如果全屏，退出
          if (widget.player.value.fullScreen) {
            player.exitFullScreen();
          } else {
            if (widget.pageContext == null) return;
            player.stop();
            Navigator.pop(widget.pageContext!);
          }
        },
      ),
    );
  }

  ///  通用容器 包含状态栏间距处理
  Widget _buildPublicFrameWidget({
    required Widget slot,
    Color? bgColor,
  }) {
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          // 视频标题,返回键
          showConfig.topBar
              ? Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Container(
                    height:
                        showConfig.stateAuto && !widget.player.value.fullScreen
                            ? barFillingHeight
                            : topBarHeight,
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      height: topBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //返回键
                          //_buildTopBackBtn(),
                          //标题
                          Expanded(
                            child: Text(
                              widget.playerTitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
          //全屏占位组件
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: showConfig.stateAuto && !widget.player.value.fullScreen
                        ? barGap
                        : 0),
                child: slot,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 错误slot
  Widget _buildErrorStateSlotWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: showConfig.stateAuto && !widget.player.value.fullScreen
                ? barGap
                : 0,
          ),
          // 失败图标
          const Icon(
            Icons.error,
            size: 50,
            color: Colors.white,
          ),
          // 错误信息
          const Text(
            "播放失败，您可以点击重试！",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // 重试
          TVWidget(
              debugLabel: "点击重试",
              onclick: () => widget.reloadClick(),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  widget.reloadClick();
                },
                child: const Text(
                  "点击重试",
                  style: TextStyle(color: Colors.black),
                ),
              )),
        ],
      ),
    );
  }

  // 加载中slot
  Widget _buildLoadingStateSlotWidget() {
    return SizedBox(
      width: topBarHeight * 0.8,
      height: topBarHeight * 0.8,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }

  // 未开始slot
  Widget _buildIdleStateSlotWidget() {
    return IconButton(
      iconSize: topBarHeight * 1.2,
      icon: const Icon(Icons.play_arrow, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      onPressed: () async {},
    );
  }

  //@override
  //bool get wantKeepAlive => true;
}

class _PanelGestureDetector extends ConsumerStatefulWidget {
  final DanmuVideoController? danmuVideoController;
  final FijkPlayer player;
  final Size viewSize;
  final Rect texturePos;
  final BuildContext? pageContext;
  final String playerTitle;
  final Function changeLockState;
  final ShowConfigAbs showConfig;
  final Widget? listViewUI;
  final LiveListController? listViewController;
  final void Function(BuildContext? context)? closeClick;
  const _PanelGestureDetector({
    Key? key,
    required this.player,
    required this.viewSize,
    required this.texturePos,
    this.pageContext,
    this.playerTitle = "",
    required this.showConfig,
    required this.changeLockState,
    required this.closeClick,
    required this.danmuVideoController,
    this.listViewUI,
    this.listViewController,
  }) : super(key: key);

  @override
  _PanelGestureDetectorState createState() => _PanelGestureDetectorState();
}

class _PanelGestureDetectorState extends ConsumerState<_PanelGestureDetector> {
  FijkPlayer get player => widget.player;
  double volume = 1.0;
  double savedVolume = 1.0;
  bool muted = false;
  ShowConfigAbs get showConfig => widget.showConfig;

  Duration _duration = const Duration();
  Duration _currentPos = const Duration();
  Duration _bufferPos = const Duration();

  // 滑动后值
  Duration _dragPos = const Duration();

  bool _isTouch = false;

  bool _playing = false;
  bool _prepared = false;
  String? _exception;

  double? updatePrevDx;
  double? updatePrevDy;
  int? updatePosX;

  bool? isDragVerLeft;

  double? updateDragVarVal;

  bool varTouchInitSuc = false;

  bool _buffering = false;

  double _seekPos = -1.0;

  StreamSubscription? _currentPosSubs;
  StreamSubscription? _bufferPosSubs;
  StreamSubscription? _bufferingSubs;

  Timer? _hideTimer;
  bool _hideStuff = true;

  bool _hideSpeedStu = true;
  bool _hideBrightSeek = true;
  double _speed = speed;
  Duration _hideDuration = Duration(milliseconds: 400);
  bool _isHorizontalMove = false;

  Map<String, double> speedList = {
    "2.0": 2.0,
    "1.8": 1.8,
    "1.5": 1.5,
    "1.2": 1.2,
    "1.0": 1.0,
  };
  void initEvent() {
    // 设置初始化的值，全屏与半屏切换后，重设
    setState(() {
      _speed = speed;
      // 每次重绘的时候，判断是否已经开始播放
      _hideStuff = !_playing ? false : true;
    });
    // 延时隐藏
    _startHideTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _hideTimer?.cancel();

    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
    _bufferingSubs?.cancel();
  }

  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;
  final VideoSliderController sliderController = VideoSliderController();

  @override
  void initState() {
    super.initState();
    _showDanmu = widget.danmuVideoController!.showBarrage;
    initEvent();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _exception = player.value.exception.message;
    _buffering = player.isBuffering;

    player.addListener(_playerValueChanged);

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      setState(() {
        _currentPos = v;
        // 后加入，处理fijkplay reset后状态对不上的bug，
        _playing = true;
        _prepared = true;
      });
    });

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      setState(() {
        _bufferPos = v;
      });
    });

    _bufferingSubs = player.onBufferStateUpdate.listen((v) {
      setState(() {
        _buffering = v;
      });
    });
    widget.listViewController?.addListener(() {
      _focusChange(true);
    });

    sliderController.addListener(() {
      _focusChange(true);
    });
    screenRecorder = HhScreenRecorder();
  }

  Map<String, dynamic>? _response;
  HhScreenRecorder? screenRecorder;

  bool? playerStateOld = null;
  void watchChange() {
    var recoding = ref.watch(recodingStartProvider);
    if (recoding) {
      playerStateOld = _playing;
    } else {
      if (playerStateOld != null && playerStateOld!) {
        player.start();
      }
      playerStateOld = null;
    }
  }

  void watchCompChange() {
    var recoding = ref.watch(recodingStartCompleteProvider);
  }

  void _playerValueChanged() async {
    FijkValue value = player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }
    if (kDebugMode) {
      print(
          '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      print('++++++++ 是否开始播放 => ${value.state == FijkState.started} ++++++++');
      print('+++++++++++++++++++ 播放器状态 => ${value.state} ++++++++++++++++++++');
      print(
          '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    }
    // 新状态
    bool playing = value.state == FijkState.started;
    bool prepared = value.prepared;
    String? exception = value.exception.message;

    // 状态不一致，修改
    if (playing != _playing ||
        prepared != _prepared ||
        exception != _exception) {
      setState(() {
        _playing = playing;
        _prepared = prepared;
        _exception = exception;
      });
    }
    value.state == FijkState.completed;
  }

  _onHorizontalDragStart(details) {
    setState(() {
      updatePrevDx = details.globalPosition.dx;
      updatePosX = _currentPos.inMilliseconds;
    });
  }

  _onHorizontalDragUpdate(details) {
    double curDragDx = details.globalPosition.dx;
    // 确定当前是前进或者后退
    int cdx = curDragDx.toInt();
    int pdx = updatePrevDx!.toInt();
    bool isBefore = cdx > pdx;

    // 计算手指滑动的比例
    int newInterval = pdx - cdx;
    double playerW = MediaQuery.of(context).size.width;
    int curIntervalAbs = newInterval.abs();
    double movePropCheck = (curIntervalAbs / playerW) * 100;

    // 计算进度条的比例
    double durProgCheck = _duration.inMilliseconds.toDouble() / 100;
    int checkTransfrom = (movePropCheck * durProgCheck).toInt();
    int dragRange =
        isBefore ? updatePosX! + checkTransfrom : updatePosX! - checkTransfrom;

    // 是否溢出 最大
    int lastSecond = _duration.inMilliseconds;
    if (dragRange >= _duration.inMilliseconds) {
      dragRange = lastSecond;
    }
    // 是否溢出 最小
    if (dragRange <= 0) {
      dragRange = 0;
    }
    //
    setState(() {
      _isHorizontalMove = true;
      _hideStuff = false;
      _isTouch = true;
      // 更新下上一次存的滑动位置
      updatePrevDx = curDragDx;
      // 更新时间
      updatePosX = dragRange.toInt();
      _dragPos = Duration(milliseconds: updatePosX!.toInt());
    });
  }

  _onHorizontalDragEnd(details) {
    player.seekTo(_dragPos.inMilliseconds);
    setState(() {
      _isHorizontalMove = false;
      _isTouch = false;
      _hideStuff = true;
      _currentPos = _dragPos;
    });
  }

  _onVerticalDragStart(details) async {
    double clientW = widget.viewSize.width;
    double curTouchPosX = details.globalPosition.dx;

    setState(() {
      // 更新位置
      updatePrevDy = details.globalPosition.dy;
      // 是否左边
      isDragVerLeft = (curTouchPosX > (clientW / 2)) ? false : true;
    });
    if (disableVerDrag) return;
    // 大于 右边 音量 ， 小于 左边 亮度
    if (!isDragVerLeft!) {
      // 音量
      await FijkVolume.getVol().then((double v) {
        varTouchInitSuc = true;
        setState(() {
          updateDragVarVal = v;
        });
      });
    } else {
      // 亮度
      await FijkPlugin.screenBrightness().then((double v) {
        varTouchInitSuc = true;
        setState(() {
          updateDragVarVal = v;
        });
      });
    }
  }

  _onVerticalDragUpdate(details) {
    if (!varTouchInitSuc) return null;
    double curDragDy = details.globalPosition.dy;
    // 确定当前是前进或者后退
    int cdy = curDragDy.toInt();
    int pdy = updatePrevDy!.toInt();
    bool isBefore = cdy < pdy;
    // + -, 不满足, 上下滑动合法滑动值，> 3
    if (isBefore && pdy - cdy < 3 || !isBefore && cdy - pdy < 3) return null;
    // 区间
    double dragRange =
        isBefore ? updateDragVarVal! + 0.03 : updateDragVarVal! - 0.03;
    // 是否溢出
    if (dragRange > 1) {
      dragRange = 1.0;
    }
    if (dragRange < 0) {
      dragRange = 0.0;
    }
    setState(() {
      updatePrevDy = curDragDy;
      varTouchInitSuc = true;
      updateDragVarVal = dragRange;
      // 音量
      if (!isDragVerLeft!) {
        FijkVolume.setVol(dragRange);
      } else {
        FijkPlugin.setScreenBrightness(dragRange);
      }
    });
  }

  _onVerticalDragEnd(details) {
    setState(() {
      varTouchInitSuc = false;
    });
  }

  bool _showDanmu = true;
  void _toggleDanmu() {
    setState(() {
      if (_showDanmu) {
        widget.danmuVideoController!.showBarrage = false;
        _showDanmu = false;
      } else {
        widget.danmuVideoController!.showBarrage = true;
        _showDanmu = true;
      }
    });
  }

  void _playOrPause() {
    if (_playing == true) {
      player.pause();
    } else {
      player.start();
    }
  }

  void _focusChange(bool focused) {
    if (focused && mounted) {
      setState(() {
        _hideStuff = false;
      });
      _startHideTimer();
    }
  }

  /// 手势点击时触发
  void _cancelAndRestartTimer() {
    if (_hideStuff == true) {
      _startHideTimer();
    }
    //修改状态
    _hideStuff = !_hideStuff;
    if (_hideStuff == true) {
      _hideSpeedStu = true;
    }
    //控制状态栏
    // _showStatusBar(!_hideStuff, fullScreen: widget.player.value.fullScreen);
    setState(() {});
  }

  /// 隐藏
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      //控制状态栏
      // if (!_hideStuff) {
      //   _showStatusBar(false, fullScreen: widget.player.value.fullScreen);
      // }
      setState(() {
        _hideStuff = true;
        _hideSpeedStu = true;
      });
    });
  }

  // 底部控制栏 - 播放按钮
  Widget _buildPlayStateBtn(String name, IconData iconData, Function cb) {
    return SizedBox(
      height: 30,
      child: TVWidget(
        debugLabel: "play state btn : ${name}",
        focusChange: _focusChange,
        margin: const EdgeInsets.all(0),
        decoration:
            BoxDecoration(color: _btnBackGround(), shape: BoxShape.circle),
        onclick: (() => cb()),
        child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Icon(
              iconData,
              color: Colors.white,
            )),
      ),
    );
  }

  static Future<bool> saveScreenShotFile(String? data) async {
    if (data == null || data.isEmpty) {
      return false;
    } else {
      //await ImageGallerySaver.saveImage(data);
      await ImageGallerySaver.saveFile(data);
      await File(data).delete();
      return true;
    }
  }

  FutureOr _saveImage() async {
    String? path = await FlutterNativeScreenshot.takeScreenshot();
    await flutterCompute(saveScreenShotFile, path).then((data) {
      if (data) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'The recoded video has been saved to media gallery'))); // showSnackBar()
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error taking the screenshot :('),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

/*
  FutureOr _saveImage() async {
    _hideDuration = Duration(milliseconds: 400);
    Uint8List? data = await FfNativeScreenshot().takeScreenshot();
//    String? path = await FlutterNativeScreenshot.takeScreenshot();
    //final data = await _takeScreenshotController.captureAsPngBytes();
    //var data = await player.takeSnapShot();
    //debugPrint(data.length);

    if (data == null || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error taking the screenshot :('),
        backgroundColor: Colors.red,
      )); // showSnackBar()
      return;
    } else {
      //await ImageGallerySaver.saveImage(new File(path).readAsBytesSync());
      await ImageGallerySaver.saveImage(data);
      //new File(path).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The screenshot has been saved to media gallery'))); // showSnackBar()

    }
  }
*/
  Future<void> startRecord({required String fileName}) async {
    try {
      ref.read(recodingStartProvider.notifier).update((state) => true);
      //Directory? tempDir = await getApplicationDocumentsDirectory();
      //String? tempPath = tempDir.path;
      var startResponse = await screenRecorder?.startRecording(
        filename: "screen",
        foldername: "record",
        recordAudio: true,
      );
      ref.read(recodingStartProvider.notifier).update((state) => false);
      if (startResponse != null && startResponse) {
        ref
            .read(recodingStartCompleteProvider.notifier)
            .update((state) => true);
      }
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }

    /*
    bool? started =
        await DeviceScreenRecorder.startRecordScreen(name: 'example');
    if (started != null && started) {
      ref.read(recodingProvider.notifier).update((state) => true);
    }
    */
    /*
    try {
      Directory? tempDir = await getApplicationDocumentsDirectory();
      String? tempPath = tempDir.path;
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: "Eren",
        //Optional. It will save the video there when you give the file path with whatever you want.
        //If you leave it blank, the Android operating system will save it to the gallery.
        dirPathToSave: tempPath,
        audioEnable: true,
      );
      var ret = startResponse?['success'].toString();
      if (ret == "true") {
        ref.read(recodingProvider.notifier).update((state) => true);
      }
      setState(() {
        _response = startResponse;
      });
      try {
        screenRecorder?.watcher?.events.listen(
          (event) {
            //debugPrint(event.type.toString());
          },
          onError: (e) => kDebugMode ? debugPrint('ERROR ON STREAM: $e') : null,
          onDone: () => kDebugMode ? debugPrint('Watcher closed!') : null,
        );
      } catch (e) {
        kDebugMode ? debugPrint('ERROR WAITING FOR READY: $e') : null;
      }
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }
     */
  }

  static Future<void> saveMediaFile(String path) async {
    //await ImageGallerySaver.saveFile(path);
    //await new File(path).delete();
  }

  Future<void> stopRecord() async {
    var ret = await screenRecorder?.stopRecording();
    if (ret != null) {
      ref.read(recodingStartCompleteProvider.notifier).update((state) => false);
      await flutterCompute(saveMediaFile, ret["filename"].toString())
          .then((data) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'The recoded video has been saved to media gallery'))); // showSnackBar()
      });
    }
    /*
    String? path = await DeviceScreenRecorder.stopRecordScreen();
    if (path != null) {
      await ImageGallerySaver.saveFile(path);
      new File(path).delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The recoded video has been saved to media gallery'))); // showSnackBar()
    }

     */
    /*

    ref.read(recodingProvider.notifier).update((state) => false);

    try {
      var stopResponse = await screenRecorder?.stopRecord();
      var ret = _response?['success'].toString();
      if (ret == "true") {
        var path = (stopResponse?['file'] as File?)?.path;
        if (path != null) {
          await ImageGallerySaver.saveFile(path);
          new File(path).delete();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'The screenshot has been saved to media gallery'))); // showSnackBar()
        }
      }
      setState(() {
        _response = stopResponse;
      });
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while stopping recording.")
          : null;
    }

     */
  }

  FutureOr<dynamic> _takeRecord(FijkPlayer player) async {
    if (!ref.read(recodingInProcessProvider)) {
      print("takeRecord===============");
      ref.read(recodingInProcessProvider.notifier).update((state) => true);
      if (!ref.read(recodingStartCompleteProvider)) {
        startRecord(fileName: "").then((data) {
          ref.read(recodingInProcessProvider.notifier).update((state) => false);
        });
      } else {
        stopRecord().then((data) {
          ref.read(recodingInProcessProvider.notifier).update((state) => false);
        });
      }
    }
  }

  FutureOr<dynamic> _takeSnapShot(FijkPlayer player) async {
    setState(() {
      _hideDuration = Duration(milliseconds: 0);
      _hideStuff = true;
      _hideSpeedStu = true;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // 画面遷移処理
      _saveImage();
    });
  }

  Widget _buildBottomBar(BuildContext context) {
    var recoding = ref.watch(recodingStartCompleteProvider);
    watchChange();
    watchCompChange();
    // 计算进度时间
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue = _seekPos > 0
        ? _seekPos
        : (_isHorizontalMove
            ? _dragPos.inMilliseconds.toDouble()
            : _currentPos.inMilliseconds.toDouble());
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);

    // 计算底部吸底进度
    double curConWidth = MediaQuery.of(context).size.width;
    double curTimePro = (currentValue / duration) * 100;
    double curBottomProW = (curConWidth / 100) * curTimePro;
    var barHeight = bottomBarHeight;
    barHeight -=
        showConfig.bottomSlideBar ? 0 : SizeConfig.blockSizeHorizontal! * 5;
    barHeight -= (widget.showConfig.showListViewUI && widget.listViewUI != null)
        ? 0
        : SizeConfig.blockSizeHorizontal! * 15;

    return SizedBox(
      height: barHeight,
      child: Stack(
        children: [
          // 底部UI控制器
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _hideStuff ? 0.0 : 0.8,
              duration: _hideDuration,
              child: Container(
                  height: barHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(0, 0, 0, 0.4),
                      ],
                    ),
                  ),
                  child: ListView(
                      scrollDirection: scrollDirection,
                      controller: controller,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Row(children: [
                            const SizedBox(width: 2),
                            // 按钮 - 播放/暂停
                            Align(
                              alignment: Alignment.centerLeft,
                              child: showConfig.bottomPlayStateBtn
                                  ? _buildPlayStateBtn(
                                      "play/pause bottom",
                                      _playing ? Icons.pause : Icons.play_arrow,
                                      _playOrPause,
                                      //(() => {widget.player.takeSnapShot()})
                                    )
                                  : Container(),
                            ),
                            const SizedBox(width: 2),
                            // 按钮 - 全屏/退出全屏
                            Align(
                              alignment: Alignment.centerLeft,
                              child: showConfig.fullScreenBtn
                                  ? _buildPlayStateBtn(
                                      "fullscreen bottom",
                                      widget.player.value.fullScreen
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      () {
                                        if (widget.player.value.fullScreen) {
                                          ref
                                              .read(fullScreenProvider.notifier)
                                              .update((state) => false);
                                          player.exitFullScreen();
                                        } else {
                                          ref
                                              .read(fullScreenProvider.notifier)
                                              .update((state) => true);
                                          final FocusScopeNode currentScope =
                                              FocusScope.of(context);
                                          if (!currentScope.hasPrimaryFocus &&
                                              currentScope.hasFocus) {
                                            FocusManager.instance.primaryFocus!
                                                .unfocus();
                                          }
                                          player.enterFullScreen();
                                        }
                                      },
                                    )
                                  : Container(),
                            ),
                            const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: _buildPlayStateBtn(
                                    "screen shot bottom", Icons.camera_alt,
                                    (() {
                                  _takeSnapShot(widget.player);
                                }))),
                            const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: _buildPlayStateBtn(
                                    "show danmu",
                                    _showDanmu
                                        ? Icons.message
                                        : Icons.speaker_notes_off, (() {
                                  _toggleDanmu();
                                }))),
                            const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: _buildPlayStateBtn(
                                    "screen shot bottom",
                                    recoding
                                        ? Icons.motion_photos_off
                                        : Icons.motion_photos_on, (() {
                                  _takeRecord(widget.player);
                                }))),

                            const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: _buildPlayStateBtn(
                                    "mute bottom",
                                    muted
                                        ? Icons.volume_off
                                        : Icons.volume_mute, (() {
                                  if (!muted) {
                                    savedVolume = volume;
                                    volume = 0;
                                  } else {
                                    volume = savedVolume;
                                  }
                                  muted = !muted;
                                  widget.player.setVolume(volume);
                                }))),
                            const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: _buildPlayStateBtn(
                                    "volume down bottom", Icons.volume_down,
                                    (() {
                                  if (muted) {
                                    volume = savedVolume;
                                    muted = !muted;
                                  }
                                  volume -= 0.1;
                                  volume = max(volume, 0);
                                  widget.player.setVolume(volume);
                                }))),
                            const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: _buildPlayStateBtn(
                                    "volume up bottom", Icons.volume_up, (() {
                                  if (muted) {
                                    volume = savedVolume;
                                    muted = !muted;
                                  }
                                  volume += 0.1;
                                  volume = min(volume, 1);
                                  widget.player.setVolume(volume);
                                }))),
                          ]),
                        ),
                        showConfig.bottomSlideBar
                            ? _buildBottomSlideBar(currentValue, duration)
                            : Container(),
                        (!widget.player.value.fullScreen &&
                                widget.showConfig.showListViewUI &&
                                widget.listViewUI != null)
                            ? widget.listViewUI!
                            : Container(),
                        /*
                        LiveListWidget(
                          liveMode: widget.liveMode,
                          imageClick: widget.imageClick,
                          focusChange: _focusChange,
                          liveFilter: (List<LiveInfo> liveFilter) => liveFilter,
                        ),

                         */
                      ])),
            ),
          ),
          // 隐藏进度条，ui隐藏时出现
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: showConfig.bottomPro &&
                    _hideStuff &&
                    _duration.inMilliseconds != 0
                ? Container(
                    alignment: Alignment.bottomLeft,
                    height: 4,
                    color: Colors.white70,
                    child: Container(
                      color: Colors.blue,
                      width: curBottomProW,
                      height: 4,
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSlideBar(currentValue, duration) {
    return SizedBox(
        height: bottomLineHeight,
        child: Row(
          children: <Widget>[
            // 已播放时间
            _duration.inMilliseconds == 0
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 5.0, left: 5),
                    child: Text(
                      _duration2String(_currentPos),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
            // 播放进度 if 没有开始播放 占满，空ui， else fijkSlider widget
            _duration.inMilliseconds == 0
                ? Expanded(
                    child:
                        Container()) /*Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: NewFijkSlider(
                        colors: const NewFijkSliderColors(
                          cursorColor: Colors.blue,
                          playedColor: Colors.blue,
                        ),
                        onChangeEnd: (double value) {},
                        value: 0,
                        onChanged: (double value) {},
                      ),
                    ),
                  )*/
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      /*child: NewFijkSlider(
                        colors: const NewFijkSliderColors(
                          cursorColor: Colors.blue,
                          playedColor: Colors.blue,
                        ),
                        value: currentValue,
                        cacheValue: _bufferPos.inMilliseconds.toDouble(),
                        min: 0.0,
                        max: duration,
                        onChanged: (v) {
                          _startHideTimer();
                          setState(() {
                            _seekPos = v;
                          });
                        },
                        onChangeEnd: (v) {
                          setState(() {
                            player.seekTo(v.toInt());
                            if (kDebugMode) {
                              print("seek to $v");
                            }
                            _currentPos =
                                Duration(milliseconds: _seekPos.toInt());
                            _seekPos = -1;
                          });
                        },
                      ),

                       */
                      child: VideoSlider(
                        controller: sliderController,
                        value: currentValue,
                        //cacheValue: _bufferPos.inMilliseconds.toDouble(),
                        min: 0.0,
                        max: duration,
                        onChanged: (v) {
                          _startHideTimer();
                          setState(() {
                            _seekPos = v;
                          });
                        },
                        onChangeEnd: (v) {
                          setState(() {
                            player.seekTo(v.toInt());
                            if (kDebugMode) {
                              print("seek to $v");
                            }
                            _currentPos =
                                Duration(milliseconds: _seekPos.toInt());
                            _seekPos = -1;
                          });
                        },
                      ),
                    ),
                  ),

            // 总播放时间
            _duration.inMilliseconds == 0
                ? const Text(
                    "LIVE",
                    style: TextStyle(color: Colors.red),
                  )
                /*const Text(
                    "00:00",
                    style: TextStyle(color: Colors.white),
                  )*/
                : Padding(
                    padding: const EdgeInsets.only(right: 5.0, left: 5),
                    child: Text(
                      _duration2String(_duration),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

            // 倍数按钮
            widget.player.value.fullScreen && showConfig.speedBtn
                ? Ink(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _hideSpeedStu = !_hideSpeedStu;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 30,
                        child: Text(
                          "$_speed X",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : Container(),

            const SizedBox(width: 7),
          ],
        ));
  }

  // 返回按钮
  Widget _buildTopBackBtn() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      color: Colors.white,
      onPressed: () {
        // 判断当前是否全屏，如果全屏，退出
        if (widget.player.value.fullScreen) {
          player.exitFullScreen();
        } else {
          if (widget.pageContext == null) return;
          player.stop();
          Navigator.pop(widget.pageContext!);
        }
      },
    );
  }

  void _onClose() {
    // 判断当前是否全屏，如果全屏，退出
    if (widget.player.value.fullScreen) {
      player.exitFullScreen();
    } else {
      if (widget.closeClick != null) {
        widget.closeClick!(widget.pageContext);
      } else {
        if (widget.pageContext == null) return;
        player.stop();
        Navigator.pop(widget.pageContext!);
      }
    }
  }

  Color _btnBackGround() {
    return const Color(0xFF424242);
  }

  Widget _buildTopCloseBtn() {
    return TVWidget(
      debugLabel: "top Close Btn",
      focusChange: _focusChange,
      margin: const EdgeInsets.all(0),
      decoration:
          BoxDecoration(color: _btnBackGround(), shape: BoxShape.circle),
      onclick: () => _onClose(),
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  // 播放器顶部 返回 + 标题
  Widget _buildTopBar() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.8,
      duration: _hideDuration,
      child: Container(
        height: showConfig.stateAuto && !widget.player.value.fullScreen
            ? barFillingHeight
            : topBarHeight,
        alignment: Alignment.bottomLeft,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.5),
              Color.fromRGBO(0, 0, 0, 0),
            ],
          ),
        ),
        child: SizedBox(
          height: topBarHeight,
          child: Row(
            children: <Widget>[
              showConfig.topBackBtn ? _buildTopBackBtn() : Container(width: 7),
              Expanded(
                child: Text(
                  widget.playerTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              showConfig.topCloseBtn ? _buildTopCloseBtn() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  // 居中播放按钮
  Widget _buildCenterPlayBtn() {
/*    if (ref.watch(fullScreenProvider)) {
      try {
        _focusNode.requestFocus();
        FocusScope.of(context).requestFocus(_focusNode);
        ref.read(fullScreenProvider.notifier).update((state) => false);
      } catch (e, s) {}
    }

 */

    return Container(
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: (_prepared && !_buffering)
            ? AnimatedOpacity(
                opacity: _hideStuff ? 0.0 : 0.7,
                duration: _hideDuration,
                child: SizedBox(
                    height: topBarHeight * 1.2,
                    child: TVWidget(
                      debugLabel: "center player button",
                      focusChange: _focusChange,
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: _btnBackGround(), shape: BoxShape.circle),
                      onclick: _playOrPause,
                      child: Icon(_playing ? Icons.pause : Icons.play_arrow,
                          color: Colors.white, size: topBarHeight * 1.2),
                    )))
            //Container()
            : SizedBox(
                width: topBarHeight * 0.8,
                height: topBarHeight * 0.8,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
      ),
    );
  }

  // build 滑动进度时间显示
  Widget _buildDargProgressTime() {
    return _isTouch
        ? Container(
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Color.fromRGBO(0, 0, 0, 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                '${_duration2String(_dragPos)} / ${_duration2String(_duration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        : Container();
  }

  // build 显示垂直亮度，音量
  Widget _buildDargVolumeAndBrightness() {
    // 不显示
    if (!varTouchInitSuc) return Container();

    IconData iconData;
    // 判断当前值范围，显示的图标
    if (updateDragVarVal! <= 0) {
      iconData = !isDragVerLeft! ? Icons.volume_mute : Icons.brightness_low;
    } else if (updateDragVarVal! < 0.5) {
      iconData = !isDragVerLeft! ? Icons.volume_down : Icons.brightness_medium;
    } else {
      iconData = !isDragVerLeft! ? Icons.volume_up : Icons.brightness_high;
    }
    // 显示，亮度 || 音量
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0.8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
            ),
            Container(
              width: 100,
              height: 3,
              margin: const EdgeInsets.only(left: 8),
              child: LinearProgressIndicator(
                value: updateDragVarVal,
                backgroundColor: Colors.white54,
                valueColor: const AlwaysStoppedAnimation(Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // build 倍数列表
  List<Widget> _buildSpeedListWidget() {
    List<Widget> columnChild = [];
    speedList.forEach((String mapKey, double speedVals) {
      columnChild.add(
        Ink(
          child: InkWell(
            onTap: () {
              if (_speed == speedVals) return;
              setState(() {
                _speed = speed = speedVals;
                _hideSpeedStu = true;
                player.setSpeed(speedVals);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 30,
              child: Text(
                "$mapKey X",
                style: TextStyle(
                  color: _speed == speedVals ? Colors.blue : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
      columnChild.add(
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            width: 50,
            height: 1,
            color: Colors.white54,
          ),
        ),
      );
    });
    columnChild.removeAt(columnChild.length - 1);
    return columnChild;
  }

  /// 播放器控制器 ui
  Widget _buildGestureDetector() {
    return GestureDetector(
      onTap: _cancelAndRestartTimer,
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      //AbsorbPointer 禁止用户输入事件
      child: AbsorbPointer(
        absorbing: _hideStuff,
        child: Column(
          children: <Widget>[
            // 播放器顶部控制器
            showConfig.topBar
                ? _buildTopBar()
                : Container(
                    height:
                        showConfig.stateAuto && !widget.player.value.fullScreen
                            ? barFillingHeight
                            : topBarHeight,
                  ),
            // 中间按钮
            Expanded(
              child: Stack(
                children: <Widget>[
                  // 顶部显示
                  Positioned(
                    top: widget.player.value.fullScreen ? 20 : 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 显示左右滑动快进时间的块
                        _buildDargProgressTime(),
                        // 显示上下滑动音量亮度
                        _buildDargVolumeAndBrightness()
                      ],
                    ),
                  ),
                  // 中间按钮
                  Align(
                    alignment: Alignment.center,
                    child: _buildCenterPlayBtn(),
                  ),
                  // 倍数选择
                  Positioned(
                    right: 35,
                    bottom: 0,
                    child: !_hideSpeedStu
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: _buildSpeedListWidget(),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  // 锁按钮
                  showConfig.lockBtn && widget.player.value.fullScreen
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedOpacity(
                            opacity: _hideStuff ? 0.0 : 0.7,
                            duration: _hideDuration,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  // 更改 ui显示状态
                                  widget.changeLockState(true);
                                },
                                icon: const Icon(Icons.lock_outline),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            // 播放器底部控制器
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGestureDetector();
  }
}

/// 显示隐藏状态栏
void _showStatusBar(bool isShow, {bool fullScreen = false}) {
  if (fullScreen) {
    // 全屏是不设置
    return;
  }
  if (isShow) {
    //状态栏显示白色文字图标
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  } else {
    //隐藏状态栏，保留底部按钮栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]); //隐藏状态栏，保留底部按钮栏
  }
}
