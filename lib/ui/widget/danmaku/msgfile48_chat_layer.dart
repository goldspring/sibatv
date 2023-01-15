import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/irc_msg.dart';
import '../dammu_video_view.dart';

const int ITEM_NUM_MAX = 10;

class MsgFile48ChatLayer extends ConsumerStatefulWidget {
  final String msgFilePath;
  final PlayerPosStreamSubscriver posStreamSubscriver;
  final DanmuVideoController _danmuVideoController;
  MsgFile48ChatLayer(
      this.msgFilePath, this.posStreamSubscriver, this._danmuVideoController);
  @override
  _MsgFile48ChatLayerState createState() => _MsgFile48ChatLayerState();
}

class _MsgFile48ChatLayerState extends ConsumerState<MsgFile48ChatLayer> {
  late List<IrcMsg> ircMsgs;
  final controller = StreamController<Duration>();

  @override
  void initState() {
    super.initState();
    ircMsgs = IrcMsg.getIrcMessages(widget.msgFilePath);
    widget.posStreamSubscriver.onUpdatePos = (cur) {
      controller.sink.add(cur);
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: controller.stream,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          Widget childWidget = Container();
          if (snapshot.hasData) {
            var index = ircMsgs.indexWhere((msg) => msg.time >= snapshot.data!);
            index = (index == -1) ? ircMsgs.length : index;
            var items = ircMsgs.isEmpty
                ? []
                : ircMsgs
                    .sublist(Math.max(0, index - ITEM_NUM_MAX), index)
                    .reversed
                    .toList();
            if (items.isNotEmpty && widget._danmuVideoController.showBarrage) {
              childWidget = ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  Widget msg = Container();
                  var nickName = items[i].nickName;
                  var text = items[i].msg;
                  var color = Colors.white;
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
                  return msg;
                },
              );
            }
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
