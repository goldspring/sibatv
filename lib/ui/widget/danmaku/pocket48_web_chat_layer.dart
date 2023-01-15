/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/pocket48_web_danmaku_provider.dart';
import '../dammu_video_view.dart';

const int ITEM_NUM_MAX = 10;

class Pocket48WebChatLayer extends ConsumerStatefulWidget {
  final int roomId;
  final DanmuVideoController _danmuVideoController;
  Pocket48WebChatLayer(this.roomId, this._danmuVideoController);
  @override
  _Pocket48WebChatLayerState createState() => _Pocket48WebChatLayerState();
}

class _Pocket48WebChatLayerState extends ConsumerState<Pocket48WebChatLayer> {
  List<dynamic> items = List<dynamic>.empty(growable: true);

  bool isCareItem(dynamic item) {
    return ((item['custom']['messageType'] == "BARRAGE_NORMAL") ||
        (item['custom']['messageType'].toString().startsWith("PRESENT_")));
  }

  @override
  Widget build(BuildContext context) {
    final lives =
        ref.watch(Pocket48WebDanmakuStreamProvider(widget.roomId).stream);
    return StreamBuilder<List<dynamic>>(
        stream: lives,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget childWidget = Container();
          if (snapshot.hasData) {
            items = snapshot.data!
                .where((msg) => isCareItem(msg))
                .toList()
                .reversed
                .take(ITEM_NUM_MAX)
                .toList();

            if (items.isNotEmpty && widget._danmuVideoController.showBarrage) {
              childWidget = ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  Widget msg = Container();
                  if (isCareItem(items[i])) {
                    var nickName = "";
                    var text = "";
                    var color = Colors.white;
                    if ((items[i]['custom']['messageType'] ==
                        "BARRAGE_NORMAL")) {
                      var user = items[i]['custom']['user'];
                      nickName = user == null ? "" : user['nickName'];
                      text = items[i]['custom']['text'];
                    } else {
                      var user = items[i]['custom']['user'];
                      nickName = user == null ? "" : user['nickName'];
                      var giftInfo = items[i]['custom']['giftInfo'];
                      text = giftInfo == null
                          ? ""
                          : "${giftInfo['giftNum']}x${giftInfo['giftName']}";
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
*/
