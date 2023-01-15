import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../repository/bilibili_danmaku_notifier.dart';

class DanmakuTile extends StatefulWidget {
  final LiveDanmakuItem danmaku;
  final double wide;
  final int pos;
  final DanmakuTileController? danmakuTileController;
  DanmakuTile(
      {required this.pos,
      required this.danmaku,
      required this.wide,
      this.danmakuTileController = null});

  @override
  _DanmakuTileState createState() => _DanmakuTileState();
}

class _DanmakuTileState extends State<DanmakuTile>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    );
    double max =
        math.max(window.physicalSize.width, window.physicalSize.height);
    animation = Tween(
            end: max - widget.danmaku.msg.length.toDouble() * 12,
            begin: -widget.danmaku.msg.length.toDouble() * 15)
        .animate(controller)
      ..addListener(
        () {
          setState(() {});
        },
      );
    controller.addListener(_animationChange);
    controller.forward();
    super.initState();
  }

  bool isCompleted = false;
  void _animationChange() {
    if (widget.danmakuTileController == null) return;
    if (isCompleted != controller.isCompleted) {
      isCompleted = controller.isCompleted;
      widget.danmakuTileController!.isCompletedChage(complete: isCompleted);
    }
  }

  @override
  void dispose() {
    //先释放controller
    controller.removeListener(_animationChange);
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: animation.value,
      top: widget.pos * widget.wide,
      child: Opacity(
        opacity: controller.isCompleted ? 0 : 1, //完成的弹幕不显示
        child: Text(
          widget.danmaku.msg,
          style: TextStyle(
            backgroundColor: Colors.black12,
            color: Colors.white,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}

class DanmakuTileController extends ChangeNotifier {
  bool isCompleted = false;
  void isCompletedChage({required bool complete}) {
    isCompleted = complete;
    notifyListeners();
  }
}
