import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sibatv/providers/bilibili_danmaku_provider.dart';

import '../../../repository/bilibili_danmaku_notifier.dart';
import '../../../utils/size_config.dart';
import '../dammu_video_view.dart';
import 'danmaku_tile.dart';

class BiliBiliDanmakuLayer extends ConsumerStatefulWidget {
  final int roomId;
  final DanmuVideoController _danmuVideoController;
  BiliBiliDanmakuLayer(this.roomId, this._danmuVideoController);

  @override
  _BiliBiliDanmakuLayerState createState() => _BiliBiliDanmakuLayerState();
}

final barrageWallController = BarrageWallController();

class _BiliBiliDanmakuLayerState extends ConsumerState<BiliBiliDanmakuLayer> {
  static final int _count = 10;
  int _pos = 0;
  final double max = SizeConfig.blockSizeHorizontal! * 100;
  static final double _wide = 20;
  List<LiveDanmakuItem> _latests =
      List.generate(_count, (index) => LiveDanmakuItem("", "", 0));
  List<LiveDanmakuItem> danmakuLists =
      List<LiveDanmakuItem>.empty(growable: true);
  //List<DanmakuTileInfo>.empty(growable: true);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lives =
        ref.watch(BiliBiliDanmakuStreamProvider(widget.roomId).stream);
    return StreamBuilder<List<dynamic>>(
        stream: lives,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget childWidget = Container();
          if (snapshot.hasData) {
            List<dynamic> items = snapshot.data!;
            Widget msg = Container();
            items.forEach((item) {
              if (item is LiveDanmakuItem) {
                LiveDanmakuItem liveDanmakuItem = item;
                if (!danmakuLists.any((element) => element == item)) {
                  danmakuLists.add(item);

                  barrageWallController.send([
                    new Bullet(
                        child: Text(item.msg,
                            style: TextStyle(
                                color: Color(4278190080 + item.color),
                                fontSize: Math.min(
                                    Math.max(item.font_size.toDouble(), 10.0),
                                    18.0))))
                  ]);
                } else {
                  danmakuLists.remove(item);
                }
              }
            });
          }

          return IgnorePointer(
              ignoring: true,
              child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Container(
                      color: Colors.transparent,
                      child: widget._danmuVideoController.showBarrage
                          ? BarrageWall(
                              massiveMode: false,
                              speed: 13,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3,
                              maxBulletHeight: 20,
                              speedCorrectionInMilliseconds: 5000,
                              controller: barrageWallController,
                              child: new Container(),
                            )
                          : Container())));
        });
  }

  ///添加一条弹幕到屏幕上
  DanmakuTileInfo? addActionDanmaku(LiveDanmakuItem item) {
    _pos = (_pos >= _count) ? 0 : _pos;
    LiveDanmakuItem latest = _latests[_pos];
    if ((item.timestamp - latest.timestamp) >
        (12000 *
            (latest.msg.length.toDouble() * 10.0) /
            (max + latest.msg.length.toDouble() * 10.0))) {
      var c = DanmakuTileController();
      var t = DanmakuTile(
          pos: _pos, danmaku: item, wide: _wide, danmakuTileController: c);
      var d = DanmakuTileInfo(tile: t, controller: c);
      _pos += 1;
      return d;
    }
    print("no pos!!!!!!!!");
    return null;
  }
}

class DanmakuTileInfo {
  final DanmakuTile tile;
  final DanmakuTileController controller;
  DanmakuTileInfo({required this.tile, required this.controller});
}
