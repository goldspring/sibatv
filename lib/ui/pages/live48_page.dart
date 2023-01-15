// TAB页面中的其中一个页面，其他类似
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sibatv/model/live_info.dart';
import 'package:sibatv/ui/pages/three_video_page.dart';
//import 'package:fluttertv/ui/widget/live_list_widget.dart';
import 'package:sibatv/ui/widget/live_list_widget.dart';
//import 'package:fluttertv/ui/bilibili/video.dart';
//?import 'package:fluttertv/ui/app/tv_player.dart';
//import 'package:fluttertv/ui/tv/tv_player.dart'; //nofade titile
//import 'package:fluttertv/ui/tiger/tv_player.dart'; //fade分享snapshot
//X Obar import 'package:fluttertv/ui/cilicili/tv_player.dart';
import 'package:sibatv/ui/widget/tv_widget.dart';
import 'package:sibatv/utils/size_config.dart';

class Live48Page extends ConsumerStatefulWidget {
  final bool liveMode;
  const Live48Page({super.key, required this.liveMode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return Live48PageState(liveMode);
  }
}

class Live48PageState extends ConsumerState<Live48Page>
    with AutomaticKeepAliveClientMixin {
  Live48PageState(bool liveMode) {}

  String _filter = r"SNH48";
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  void _teamFilter(String team, bool focused) {
    setState(() {
      if (!focused) return;
      _filter = team;
      controller.scrollToIndex(1, preferPosition: AutoScrollPosition.begin);
    });
  }

  List<Widget> _contents() {
    return <Widget>[
      SizedBox(
          width: SizeConfig.blockSizeHorizontal! * 100,
          child: LiveListWidget(
            liveMode: widget.liveMode,
            imageClick: _click,
          )),
      SizedBox(
          height: SizeConfig.blockSizeHorizontal! * 3,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _filterBox("SNH48"),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 1,
              ),
              _filterBox("GNZ48"),
            ],
          )),
      SizedBox(
          width: SizeConfig.blockSizeHorizontal! * 100,
          child: LiveListWidget(
              liveMode: widget.liveMode,
              imageClick: _click,
              liveFilter: (List<LiveInfo> liveFilter) => liveFilter
                  .where((element) =>
                      RegExp(_filter).hasMatch(element.userInfo.nickname))
                  .toList()))
    ];
  }

  Widget _filterBox(String team) {
    return DecoratedBox(
        decoration: const BoxDecoration(
            color: Color(0xFF424242),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: TVWidget(
          debugLabel: "filter ${team}",
          focusedTextStyle: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.blockSizeHorizontal! * 2,
          ),
          defaultTextStyle: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.blockSizeHorizontal! * 2,
          ),
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          focusChange: ((focused) => _teamFilter(team, focused)),
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal! / 3),
                  child: Text(team))),
        ));
  }

  Widget _getRow(int index, Widget content) {
    return _wrapScrollTag(
      index: index,
      child: content,
    );
  }

  Widget _wrapScrollTag({required int index, required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Container(
            color: Colors.black87,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListView(
              scrollDirection: scrollDirection,
              controller: controller,
              children: _contents().asMap().entries.map((entry) {
                int index = entry.key;
                return _getRow(index, entry.value);
              }).toList(),
            )));
  }

  void _click(String liveId) {
    print("TVWidget click!!");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ThreeVideoPage(liveId: liveId, liveMode: widget.liveMode);
    }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
