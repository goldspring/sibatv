import 'package:dio/dio.dart';

import '../../model/bilibili_live_item.dart';

class LiveApi {
  static Future getLivePlayUrl(String roomid) async {
    String url =
        "https://api.live.bilibili.com/room/v1/Room/playUrl?cid=$roomid&quality=10000&platform=web";
    print(url);
    Dio dio = Dio();
    try {
      Response res = await dio.get(url,
          options: Options(
            receiveTimeout: 5000,
            sendTimeout: 5000,
          ));

      if (res.data["data"]["durl"] != null) {
        List<String> list = [];
        for (Map<String, dynamic> i in res.data["data"]["durl"]) {
          if (i != null && i["url"] != null) {
            list.add(i["url"]);
          }
        }
        return list;
      }
      return null;
    } catch (e) {
      print(e.toString());
      print("获取播放列表失败");
      return null;
    }
  }

  static Future<List<String>> getLunboPlayUrl(String roomid) async {
    String url = await getRoundInfoUrl(roomid);
    if (url.isEmpty) return List<String>.empty(growable: true);
    String playUrl = await getRoundPlayUrl(url);
    return [playUrl];
    //return ['assets/akb48.mp4'];
  }

  static Future<String> getRoundInfoUrl(String roomid) async {
    var now = DateTime.now().millisecondsSinceEpoch;
    //1656812669863
    print(now);

    String url =
        "https://api.live.bilibili.com/live/getRoundPlayVideo?room_id=$roomid&a=$now&type=flv";
    Dio dio = Dio();
    try {
      Response res = await dio.get(url,
          options: Options(
            receiveTimeout: 5000,
            sendTimeout: 5000,
          ));

      if (res.data["data"]["play_url"] != null) {
        return res.data["data"]["play_url"];
      }
      return "";
    } catch (e) {
      print(e.toString());
      print("获取播放列表失败");
      return "";
    }
  }

  static Future<String> getRoundPlayUrl(String url) async {
    Dio dio = Dio();
    try {
      Response res = await dio.get(url,
          options: Options(
            receiveTimeout: 5000,
            sendTimeout: 5000,
          ));

      if (res.data["accept_quality"] != null) {
        var aq = res.data["accept_quality"];
      }
      if (res.data["durl"] != null &&
          res.data["durl"][0] != null &&
          res.data["durl"][0]["url"] != null) {
        return res.data["durl"][0]["url"];
      }

      return "";
    } catch (e) {
      print(e.toString());
      print("获取播放列表失败");
      return "";
    }
  }

  static getLiveList() async {
    List livelist = List.empty(growable: true);
    try {
      Dio dio = Dio();
      String url =
          "https://api.live.bilibili.com/room/v1/AppIndex/getAllList?device=android&platform=android&scale=xhdpi";
      Response res = await dio.get(url,
          options: Options(
            receiveTimeout: 5000,
            sendTimeout: 5000,
          ));
      //TODO 去除固定数据
      AreaCard areaCard = AreaCard([
        AreaItem(
          "http://i0.hdslb.com/bfs/vc/dcfb14f14ec83e503147a262e7607858b05d7ac0.png",
          "英雄联盟",
        ),
        AreaItem(
          "http://i0.hdslb.com/bfs/vc/c666c6dc2d5346e0d3cfda7162914d84d16964dd.png",
          "lol云顶之弈",
        ),
        AreaItem(
          "http://i0.hdslb.com/bfs/vc/8f7134aa4942b544c4630be3e042f013cc778ea2.png",
          "王者荣耀",
        ),
        AreaItem(
            "http://i0.hdslb.com/bfs/live/8fd5339dac84ec34e72f707f4c3b665d0aa41905.png",
            "娱乐"),
        AreaItem(
            "http://i0.hdslb.com/bfs/live/827033eb0ac50db3d9f849abe8e39a5d3b1ecd53.png",
            "单机"),
        AreaItem(
            "http://i0.hdslb.com/bfs/live/a7adae1f7571a97f51d60f685823acc610d00a7e.png",
            "电台"),
        AreaItem(
            "http://i0.hdslb.com/bfs/vc/9bfde767eae7769bcaf9156d3a7c4df86632bd03.png",
            "怪物猎人:世界"),
        AreaItem(
            "http://i0.hdslb.com/bfs/vc/973d2fe12c771207d49f6dff1440f73d153aa2b2.png",
            "无主之地3"),
        AreaItem(
            "http://i0.hdslb.com/bfs/vc/976be38da68267cab88f92f0ed78e057995798d6.png",
            "第五人格"),
        AreaItem(
            "https://i0.hdslb.com/bfs/vc/ff03528785fc8c91491d79e440398484811d6d87.png",
            "全部标签"),
      ]);
      Banners temp = Banners.fromJson(res.data["data"]);
      livelist.add(temp);
      livelist.add(areaCard);
      for (Map<String, dynamic> p in res.data["data"]["partitions"]) {
        livelist.add(LivePartition.fromJson(p));
      }
      return livelist;
    } catch (e) {
      print(e.toString());
      return livelist;
    }
  }

  static Future<BiliLiveInfo?> getLiveInfo(String roomid) async {
    print("Bilibili API getLiveInfo");
    try {
      Dio dio = Dio();
      String url =
          "https://api.live.bilibili.com/room/v1/Room/get_info?id=$roomid";
      Response res = await dio.get(
        url,
        options: Options(
          receiveTimeout: 5000,
          sendTimeout: 5000,
        ),
      );
      if (res.data["code"] == 0) {
        return BiliLiveInfo.fromJson(res.data["data"]);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<String>> getLiveOrLunbo(String roomId) async {
    print("Bilibili API getLiveOrLunbo");
    var info = await LiveApi.getLiveInfo(roomId);
    if (info != null) {
      if (info.liveStatus == 1) {
        return await getLiveUrl(roomId);
      } else if (info.liveStatus == 2) {
        return await getLunboUrl(roomId);
      } else {
        print("unknown liveStatus");
      }
    }
    return List<String>.empty(growable: true);
  }

  static Future<List<String>> getLiveUrl(String roomId) async {
    List<String> ulrList = List<String>.empty(growable: true);
    var res = await LiveApi.getLivePlayUrl(roomId);
    if (res != null) {
      print("live urls: $res");
      ulrList.addAll(res);
    }
    return ulrList;
  }

  static Future<List<String>> getLunboUrl(String roomId) async {
    List<String> ulrList = List<String>.empty(growable: true);
    var res = await LiveApi.getLunboPlayUrl(roomId);
    if (res != null) {
      print("lunbo urls: $res");
      ulrList.addAll(res);
    }
    return ulrList;
  }
}

class BiliLiveInfo {
  String title = "";
  int online = 0;
  bool isPortrait = false;

  ///ture为竖屏，flase为横屏
  int attention = 0;
  int liveStatus = 0;
  String description = "";
  String background = "";
  String userCover = "";

  ///0未开播，1开播,2轮播-不好播放
  String areaName = "";
  BiliLiveInfo.fromJson(Map<String, dynamic> jd) {
    title = jd["title"];
    online = jd["online"];
    isPortrait = jd["is_portrait"];
    liveStatus = jd["live_status"];
    areaName = jd["area_name"];
    attention = jd["attention"];
    description = jd["description"];
    background = jd["background"];
    userCover = jd["user_cover"];
  }
}
