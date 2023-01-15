import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ls_netchat_plugin/login_data.dart';
import 'package:ls_netchat_plugin/message_data.dart';

import '../../../providers/pocket48_danmaku_provider.dart';
import '../dammu_video_view.dart';

const int ITEM_NUM_MAX = 10;

class Pocket48ChatLayer extends ConsumerStatefulWidget {
  final int roomId;
  final DanmuVideoController _danmuVideoController;

  Pocket48ChatLayer(this.roomId, this._danmuVideoController);
  @override
  _Pocket48ChatLayerState createState() => _Pocket48ChatLayerState();
}

class _Pocket48ChatLayerState extends ConsumerState<Pocket48ChatLayer> {
  List<NIMessage> items = List<NIMessage>.empty(growable: true);

  bool isCareItem(NIMessage item) {
    return ((item.messageType == "BARRAGE_NORMAL") ||
        (item.messageType.startsWith("PRESENT_")));
  }

  @override
  void initState() {
    super.initState();
    _refreshRoomInfos();
    _startRoomInfoTimer();
  }

  void _refreshRoomInfos() {
    ref.refresh(Pocket48RoomInfoStateStreamProvider(widget.roomId.toString()));
  }

  Timer? _refreshTimer;
  void _startRoomInfoTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (t) {
      _refreshRoomInfos();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(
        Pocket48RoomInfoStateStreamProvider(widget.roomId.toString()).stream);

    final lives =
        ref.watch(Pocket48DanmakuStreamProvider(widget.roomId).stream);

    return StreamBuilder<List<NIMessage>>(
        stream: lives,
        builder:
            (BuildContext context, AsyncSnapshot<List<NIMessage>> snapshot) {
          Widget childWidget = Container();
          if (snapshot.hasData) {
            items = snapshot.data!
                .where((msg) => isCareItem(msg))
                .toList()
                .reversed
                .take(ITEM_NUM_MAX)
                .toList();

            Widget msgs = Container();
            if (items.isNotEmpty && widget._danmuVideoController.showBarrage) {
              msgs = Container(
                  alignment: Alignment.bottomCenter,
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      Widget msg = Container();
                      if (isCareItem(items[i])) {
                        var nickName = "";
                        var text = "";
                        var color = Colors.white;
                        nickName = items[i].nicName;
                        text = items[i].content;
                        if ((items[i].messageType == "BARRAGE_NORMAL")) {
                          color = Colors.white;
                        } else {
                          color = Colors.yellowAccent;
                        }

                        msg = Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                " ${nickName} : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                    backgroundColor: Colors.black45),
                              ),
                              Expanded(
                                child: Text("${text}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: color,
                                        backgroundColor: Colors.black45)),
                              )
                            ],
                          ),
                        );
                      } else {
                        //print("no care:" + items[i]['custom']['messageType']);
                      }
                      return msg;
                    },
                  ));
            }
            childWidget = Stack(children: <Widget>[
              msgs,
              Positioned(
                top: 10.0,
                left: 20.0,
                child: Container(
                  alignment: Alignment(0.0, 0.0),
                  color: Colors.transparent,
                  child: StreamBuilder<ChatRoomInfoData>(
                      stream: online,
                      builder: (context, snapshot) {
                        var onlineNum = (snapshot.hasData &&
                                !snapshot.hasError &&
                                snapshot.data != null)
                            ? snapshot.data!.onlineUserCount.toString() + "人 在线"
                            : "";
                        return Text(
                          onlineNum,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        );
                      }),
                ),
              ),
            ]);
          }
          return IgnorePointer(
              ignoring: true,
              child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Container(
                      color: Colors.transparent, child: childWidget)));
        });
  }
}
