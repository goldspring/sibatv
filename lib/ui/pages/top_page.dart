import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hh_screen_recorder/hh_screen_recorder.dart';
import 'package:ls_netchat_plugin/lsnetchatplugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sibatv/ui/widget/tv_widget.dart';
import 'package:sibatv/utils/size_config.dart';
import 'package:sibatv/utils/time_utils.dart';

import '../../constant/room_id.dart';
import '../../env/env.dart';
import '../../providers/live_provider.dart';
import '../../providers/tab_provider.dart';
import '../../utils/bilibili_live_api.dart';
import '../widget/custom_tab_bar.dart';
import 'bili_play_page.dart';
import 'live48_page.dart';

class TopPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return TopPageState();
  }
}

class NoAnimationTabController extends TabController {
  NoAnimationTabController(
      {int initialIndex = 0,
      required int length,
      required TickerProvider vsync})
      : super(initialIndex: initialIndex, length: length, vsync: vsync);

  @override
  void animateTo(int value,
      {Duration? duration = kTabScrollDuration, Curve curve = Curves.ease}) {
    super.animateTo(value,
        duration: const Duration(milliseconds: 0), curve: curve);
  }
}

class TopPageState extends ConsumerState<TopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Timer timer;
  var timeString = TimeUtils.getTime();
  bool init = false;
  late List<FocusNode> _focusNodes;
  @override
  void initState() {
    super.initState(); //initialIndex为初始选中第几个，length为数量
    _startTimeout();
    _startLiveMarkTimer();
    _refreshMarks();
    _reloadLiveList();
    _focusNodes = [
      FocusNode(
          debugLabel: "d直播",
          canRequestFocus: false,
          descendantsAreFocusable: false),
      FocusNode(
          debugLabel: "d重播",
          canRequestFocus: false,
          descendantsAreFocusable: false),
      FocusNode(
          debugLabel: "dGNZ48",
          canRequestFocus: false,
          descendantsAreFocusable: false),
      FocusNode(
          debugLabel: "dTEAM SH",
          canRequestFocus: false,
          descendantsAreFocusable: false),
      FocusNode(
          debugLabel: "dSNH48",
          canRequestFocus: false,
          descendantsAreFocusable: false),
      FocusNode(
          debugLabel: "dBej48",
          canRequestFocus: false,
          descendantsAreFocusable: false),
      FocusNode(
          debugLabel: "XOX",
          canRequestFocus: false,
          descendantsAreFocusable: false)
    ];
    _tabController = TabController(
        initialIndex: 0,
        length: 7,
        vsync: this,
        animationDuration: Duration.zero);
    _tabController.addListener(() {
      ref
          .read(tabPageProvider.notifier)
          .update((state) => _tabController.index);
    });

    Lsnetchatplugin.initChatUtil(Env.nimApiKey);
    /*
    NimCore.instance.initialize(options).then((result) {
      if (result.isSuccess) {
        NimCore.instance.chatroomService
            .enterChatroom(
          NIMChatroomEnterRequest(
            roomId: '3868306',
            nickname: '48superXox',
            avatar:
                'https://www.pngall.com/wp-content/uploads/2016/04/Jaguar-PNG-HD.png',
            retryCount: 3,
            independentModeConfig: NIMChatroomIndependentModeConfigDesktop(
              appKey: String.fromEnvironment('NIM_API_KEY'),
              linkAddresses: String.fromEnvironment('NIM_LINKADDR'),
            ),
          ),
        )
            .then((result) {
          if (result.isSuccess) {
            /// 加入独立聊天室成功
            print("ok");
          } else {
            /// 加入独立聊天室失败
            print("nng");
          }
        });
      } else {
        /// 加入聊天室失败
        print("ng");
      }
    });

     */
    screenRecorder = HhScreenRecorder();
  }

  HhScreenRecorder? screenRecorder;

  Future<void> _startRec() async {
    try {
      Directory? tempDir = await getApplicationDocumentsDirectory();
      String? tempPath = tempDir.path;
      var startResponse = await screenRecorder?.startRecording(
        filename: "Eren",
        foldername: tempPath,
        recordAudio: true,
      );
      if (startResponse != null && startResponse) {
        ref
            .read(recodingStartCompleteProvider.notifier)
            .update((state) => true);
      }
    } on PlatformException {
      debugPrint("Error: An error occurred while starting the recording!");
    }
  }

  Future<void> _stopRec() async {
    try {
      Directory? tempDir = await getApplicationDocumentsDirectory();
      String? tempPath = tempDir.path;
      var startResponse = await screenRecorder?.stopRecording();
      if (startResponse != null) {
        debugPrint("not");
      }
    } on PlatformException {
      debugPrint("Error: An error occurred while starting the recording!");
    }
  }

  void _reloadLiveList() {
    var live = ref.read(pocket48LiveProvider(true).notifier);
    live.requestLiveList();
    live = ref.read(pocket48LiveProvider(false).notifier);
    live.requestLiveList();
  }

  void _startTimeout() {
    timer = Timer.periodic(Duration(minutes: 1), (t) {
      _reloadLiveList();
      setState(() {
        timeString = TimeUtils.getTime();
      });
    });
  }

  void _refreshMarks() {
    ref.refresh(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_SNH48));
    ref.refresh(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_GNZ48));
    ref.refresh(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_BEJ48));
    ref.refresh(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_TEAMSH));
    ref.refresh(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_XOX));
  }

  Timer? _refreshTimer;
  void _startLiveMarkTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (t) {
      _refreshMarks();
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TVWidget(
                debugLabel: "will pop No",
                child: Text('No'),
                onclick: () =>
                    Navigator.of(context).pop(false), // <-- SEE HERE,
              ),
              TVWidget(
                debugLabel: "will pop Yes",
                child: Text('Yes'),
                onclick: () => Navigator.of(context).pop(true), // <-- SEE HERE,
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final snhMark = ref
        .watch(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_SNH48).stream);
    final gnzMark = ref
        .watch(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_GNZ48).stream);
    final bejMark = ref
        .watch(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_BEJ48).stream);
    final shMark = ref
        .watch(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_TEAMSH).stream);
    final xoxMark =
        ref.watch(bilibiliRoomStateStreamProvider(RoomIds.BILIBILI_XOX).stream);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(30),
          child: // A group that is ordered with a numerical order, from left to right.
              FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 30,
                      backgroundColor: Colors.black87,
                      leading: const Icon(
                        Icons.live_tv,
                        color: Colors.deepOrange,
                        size: 30,
                      ),
                      title: const Text(
                        '丝芭TV',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                      ),
                      primary: true,
                      actions: <Widget>[
                        Column(children: [
                          SizedBox(height: 5),
                          Text('$timeString',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white))
                        ]),
                      ],
                      bottom: CustomTabBar(
                        controller: _tabController,
                        indicatorColor: Colors.deepOrange,
                        labelColor: Colors.deepOrange,
                        unselectedLabelColor: Colors.white,
                        focusNodes: _focusNodes,
                        tabs: <Widget>[
                          TVWidget(
                            order: NumericFocusOrder(1.0),
                            debugLabel: '直播',
                            hasDecoration: false,
                            focusChange: (hasFocus) {
                              if (hasFocus) {
                                setState(() {
                                  _tabController.animateTo(0);
                                });
                              }
                            },
                            child: Text(
                              '直播',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TVWidget(
                            order: NumericFocusOrder(2.0),
                            debugLabel: '重播',
                            hasDecoration: false,
                            focusChange: (hasFocus) {
                              if (hasFocus) {
                                setState(() {
                                  _tabController.animateTo(1);
                                });
                              }
                            },
                            child: const Text(
                              '重播',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TVWidget(
                              order: NumericFocusOrder(3.0),
                              debugLabel: 'GNZ48',
                              hasDecoration: false,
                              focusChange: (hasFocus) {
                                if (hasFocus) {
                                  setState(() {
                                    _tabController.animateTo(2);
                                  });
                                }
                              },
                              onclick: () {
                                refreshRoom(RoomIds.BILIBILI_GNZ48);
                              },
                              child: StreamBuilder<BiliLiveInfo?>(
                                  stream: gnzMark,
                                  builder: (context, snapshot) {
                                    var isLive = (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data!.liveStatus == 1);
                                    var c = isLive
                                        ? Icon(Icons.videocam,
                                            color: Colors.red)
                                        : Container();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'GNZ48',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        c
                                      ],
                                    );
                                  })),
                          TVWidget(
                              order: NumericFocusOrder(4.0),
                              debugLabel: 'TeamSH',
                              hasDecoration: false,
                              focusChange: (hasFocus) {
                                if (hasFocus) {
                                  setState(() {
                                    _tabController.animateTo(3);
                                  });
                                }
                              },
                              onclick: () {
                                refreshRoom(RoomIds.BILIBILI_TEAMSH);
                              },
                              child: StreamBuilder<BiliLiveInfo?>(
                                  stream: shMark,
                                  builder: (context, snapshot) {
                                    var isLive = (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data!.liveStatus == 1);
                                    var c = isLive
                                        ? Icon(Icons.videocam,
                                            color: Colors.red)
                                        : Container();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'TeamSH',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        c
                                      ],
                                    );
                                  })),
                          TVWidget(
                              order: NumericFocusOrder(5.0),
                              debugLabel: 'SNH48',
                              hasDecoration: false,
                              focusChange: (hasFocus) {
                                if (hasFocus) {
                                  setState(() {
                                    _tabController.animateTo(4);
                                  });
                                }
                              },
                              onclick: () {
                                refreshRoom(RoomIds.BILIBILI_SNH48);
                              },
                              child: StreamBuilder<BiliLiveInfo?>(
                                  stream: snhMark,
                                  builder: (context, snapshot) {
                                    var isLive = (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data!.liveStatus == 1);
                                    var c = isLive
                                        ? Icon(Icons.videocam,
                                            color: Colors.red)
                                        : Container();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'SNH48',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        c
                                      ],
                                    );
                                  })),
                          TVWidget(
                              order: NumericFocusOrder(6.0),
                              debugLabel: 'BEJ48',
                              hasDecoration: false,
                              focusChange: (hasFocus) {
                                if (hasFocus) {
                                  setState(() {
                                    _tabController.animateTo(5);
                                  });
                                }
                              },
                              onclick: () {
                                refreshRoom(RoomIds.BILIBILI_BEJ48);
                              },
                              child: StreamBuilder<BiliLiveInfo?>(
                                  stream: bejMark,
                                  builder: (context, snapshot) {
                                    var isLive = (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data!.liveStatus == 1);
                                    var c = isLive
                                        ? Icon(Icons.videocam,
                                            color: Colors.red)
                                        : Container();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'BEJ48',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        c
                                      ],
                                    );
                                  })),
                          TVWidget(
                              order: NumericFocusOrder(7.0),
                              debugLabel: 'XOX',
                              hasDecoration: false,
                              focusChange: (hasFocus) {
                                if (hasFocus) {
                                  setState(() {
                                    _tabController.animateTo(6);
                                  });
                                }
                              },
                              onclick: () {
                                refreshRoom(RoomIds.BILIBILI_XOX);
                              },
                              child: StreamBuilder<BiliLiveInfo?>(
                                  stream: xoxMark,
                                  builder: (context, snapshot) {
                                    var isLive = (snapshot.hasData &&
                                        !snapshot.hasError &&
                                        snapshot.data!.liveStatus == 1);
                                    var c = isLive
                                        ? Icon(Icons.videocam,
                                            color: Colors.red)
                                        : Container();
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'XOX',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        c
                                      ],
                                    );
                                  })),
                        ],
                      ),
                    ),
                    body: TabBarView(controller: _tabController, children: [
                      Live48Page(liveMode: true),
                      Live48Page(liveMode: false),
                      BilibiliPlayPage(2, RoomIds.BILIBILI_GNZ48,
                          cover: "", userName: "GNZ48"),
                      BilibiliPlayPage(3, RoomIds.BILIBILI_TEAMSH,
                          cover: "", userName: "TeamSH"),
                      BilibiliPlayPage(4, RoomIds.BILIBILI_SNH48,
                          cover: "", userName: "SNH48"),
                      BilibiliPlayPage(5, RoomIds.BILIBILI_BEJ48,
                          cover: "", userName: "BEJ48"),
                      BilibiliPlayPage(6, RoomIds.BILIBILI_XOX,
                          cover: "", userName: "XOX"),
                    ]),
                  ))),
    );
  }

  void refreshRoom(String roomId) {
    ref.refresh(biliLiveInfoProvider(roomId));
    ref.refresh(biliLiveUrlsProvider(roomId));
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    _refreshTimer?.cancel();
    super.dispose();
  }
}
