import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:sibatv/model/live_info.dart';
import 'package:sibatv/ui/widget/tv_widget.dart';
import 'package:sibatv/utils/size_config.dart';

import '../../providers/live_provider.dart';
import '../../utils/time_utils.dart';

class LiveListWidget extends ConsumerStatefulWidget {
  final bool liveMode;
  final List<LiveInfo> Function(List<LiveInfo>)? liveFilter;
  final void Function(String liveId) imageClick;
  final void Function(bool)? focusChange;
  final LiveListController? controller;
  LiveListWidget(
      {super.key,
      required this.liveMode,
      required this.imageClick,
      this.controller,
      this.liveFilter,
      this.focusChange});
  @override
  LiveListState createState() => LiveListState();
}

class LiveListState extends ConsumerState<LiveListWidget> {
  Timer? _refreshTimer;
  @override
  void initState() {
    super.initState();
    //ref.refresh(pocket48LiveStreamProvider(widget.liveMode));
//
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startHideLockTimer();
    //ref.refresh(pocket48LiveStreamProvider(widget.liveMode));
  }

  void _startHideLockTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer(const Duration(seconds: 1), () {
      ref.refresh(pocket48LiveStreamProvider(widget.liveMode));
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lives = ref.watch(pocket48LiveStreamProvider(widget.liveMode).stream);
    List<LiveInfo> Function(List<LiveInfo>) defaultfilter =
        (List<LiveInfo> filter) => filter;
    var filter = widget.liveFilter ?? defaultfilter;
    return StreamBuilder<List<LiveData>>(
        stream: lives,
        builder:
            (BuildContext context, AsyncSnapshot<List<LiveData>> snapshot) {
          Widget childWidget;
          if (snapshot.hasData) {
            var items = filter(snapshot.data!.fold(List<LiveInfo>.empty(),
                (value, element) => value + element.content.liveList));
            if (items.isNotEmpty) {
              childWidget = FocusTraversalGroup(
                  policy: OrderedTraversalPolicy(),
                  child: SizedBox(
                      height: SizeConfig.blockSizeHorizontal! * 20,
                      child: LazyLoadScrollView(
                          scrollDirection: Axis.horizontal,
                          onEndOfPage: () => _loadMore(snapshot.data!),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                LiveInfo liveInfo = items[index];
                                return SizedBox(
                                  width: SizeConfig.blockSizeHorizontal! * 20,
                                  child: _buildImageItem(liveInfo,
                                      focusChange: (items.length - 1) == index
                                          ? (focus) {
                                              if (widget.focusChange != null) {
                                                widget.focusChange!(focus);
                                              }
                                              if (focus) {
                                                widget.controller
                                                    ?.gotFocus(focus: focus);
                                                _loadMore(snapshot.data!);
                                              }
                                            }
                                          : (focus) {
                                              if (widget.focusChange != null) {
                                                widget.focusChange!(focus);
                                              }
                                              if (focus) {
                                                widget.controller
                                                    ?.gotFocus(focus: focus);
                                              }
                                            }),
                                );
                              }))));
            } else {
              childWidget = SizedBox(
                  height: SizeConfig.blockSizeHorizontal! * 20,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Icon(
                          Icons.sentiment_neutral,
                          color: Colors.white,
                        ),
                        Text("这里没有人",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeHorizontal!,
                            )),
                      ])));
            }
          } else {
            childWidget = SizedBox(
                height: SizeConfig.blockSizeHorizontal! * 20,
                child: const Center(child: CircularProgressIndicator()));
          }
          return childWidget;
        });
  }

  void _loadMore(List<LiveData> liveContent) {
    if (kDebugMode) {
      print("loadMore!!");
    }
    if (liveContent.last.content.next == "0") {
      return;
    }
    ref
        .read(pocket48LiveProvider(widget.liveMode).notifier)
        .requestLiveList(next: liveContent.last.content.next);
  }

  TVWidget _buildImageItem(LiveInfo liveInfo,
      {required void Function(bool)? focusChange}) {
    String liveId = liveInfo.liveId;
    String nickName = liveInfo.userInfo.nickname;
    String title = liveInfo.title;
    String imageUrl = 'https://source.48.cn${liveInfo.coverPath}';
    int liveType = liveInfo.liveType;
    int liveMode = liveInfo.liveMode;
    int status = liveInfo.status;
    String ctime = liveInfo.ctime;

    String videoType = "录屏";
    var videoTypeColor = Colors.lightBlueAccent;
    if (liveMode == 0) {
      if (liveType == 1) {
        videoType = "视频";
        videoTypeColor = Colors.deepPurpleAccent;
      } else {
        videoType = "电台";
        videoTypeColor = Colors.orangeAccent;
      }
    }

    String recordType = "LIVE";
    var recordTypeColor = Colors.red;
    if (status == 3) {
      recordType = TimeUtils.getDateFromUnixTime(ctime);
      recordTypeColor = Colors.grey;
    }

    return TVWidget(
      onclick: (() async => widget.imageClick(liveId)),
      focusChange: focusChange,
      debugLabel: nickName,
      child: GestureDetector(
        onTap: () async {
          widget.imageClick(liveId);
        },
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(0),
          color: Colors.black,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: OptimizedCacheImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container())),
                ),
                Container(
                    constraints: const BoxConstraints.expand(),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: recordTypeColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal! / 50,
                                bottom: SizeConfig.blockSizeHorizontal! / 50,
                                left: SizeConfig.blockSizeHorizontal! / 3,
                                right: SizeConfig.blockSizeHorizontal! / 3),
                            child: Text(recordType,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockSizeHorizontal!,
                                ))),
                      ),
                    )),
                Container(
                    constraints: const BoxConstraints.expand(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: videoTypeColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal! / 50,
                                bottom: SizeConfig.blockSizeHorizontal! / 50,
                                left: SizeConfig.blockSizeHorizontal! / 3,
                                right: SizeConfig.blockSizeHorizontal! / 3),
                            child: Text(videoType,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.blockSizeHorizontal!,
                                ))),
                      ),
                    ))
              ]),
              Container(
                color: Colors.black.withAlpha(240),
                padding: const EdgeInsets.all(5),
                child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(nickName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamilyFallback: ['Color Emoji'],
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveListController extends ChangeNotifier {
  void gotFocus({required bool focus}) {
    notifyListeners();
  }
}
