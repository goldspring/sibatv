import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sibatv/providers/bilibili_danmaku_provider.dart';

import '../../../repository/bilibili_danmaku_notifier.dart';
import '../dammu_video_view.dart';

const int ITEM_NUM_MAX = 50;

class BiliBiliChatLayer extends ConsumerStatefulWidget {
  final int roomId;
  final DanmuVideoController _danmuVideoController;
  BiliBiliChatLayer(this.roomId, this._danmuVideoController);
  @override
  _BiliBiliChatLayerState createState() => _BiliBiliChatLayerState();
}

class _BiliBiliChatLayerState extends ConsumerState<BiliBiliChatLayer> {
  //List<LiveDanmakuItem> msgs = List<LiveDanmakuItem>.empty(growable: true);
  List<dynamic> items = List<dynamic>.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    final lives =
        ref.watch(BiliBiliDanmakuStreamProvider(widget.roomId).stream);
    return StreamBuilder<List<dynamic>>(
        stream: lives,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget childWidget = Container();
          if (snapshot.hasData) {
            List<dynamic> msgs = snapshot.data!;
            msgs.forEach((msg) {
              if (!items.any((element) => element == msg)) {
                items.insert(0, msg);
                if (items.length > ITEM_NUM_MAX) {
                  items.removeLast();
                }
              }
            });
            //msgs = msgs+ items;
            if (items.isNotEmpty && widget._danmuVideoController.showBarrage) {
              childWidget = ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  Widget msg = Container();
                  if (items[i] is LiveDanmakuItem) {
                    LiveDanmakuItem liveDanmakuItem = items[i];
                    msg = Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            " ${liveDanmakuItem.name} : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                backgroundColor: Colors.black45),
                          ),
                          Expanded(
                            child: Text("${liveDanmakuItem.msg}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    backgroundColor: Colors.black45)),
                          )
                        ],
                      ),
                    );
                  } else if (items[i] is GiftItem) {
                    GiftItem giftItem = items[i];
                    msg = Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            " ${giftItem.name} ",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Expanded(
                            child: Text(
                              "${giftItem.action} ${giftItem.count} 个 ${giftItem.msg}",
                            ),
                          )
                        ],
                      ),
                    );
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
