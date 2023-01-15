import '../utils/my_math.dart';

class BannerItem {
  String pic = "";
  String id = "";
  String postition = "";
  String title = "";
  String link = "";
  BannerItem(
      {required this.id,
      required this.link,
      required this.pic,
      required this.postition,
      required this.title});
  BannerItem.fromJson(Map<String, dynamic> jsondata) {
    pic = jsondata["pic"];
    id = jsondata["id"];
    postition = jsondata["postition"];
    title = jsondata["title"];
    link = jsondata["link"];
  }
}

class Banners {
  List<BannerItem> list = List<BannerItem>.empty(growable: true);
  Banners.fromJson(Map<String, dynamic> jd) {
    list = List<BannerItem>.empty(growable: true);
    for (Map<String, dynamic> item in jd["banner"]) {
      list.add(BannerItem.fromJson(item));
    }
  }
}

class LivePartition {
  int id = 0;
  String name = "";
  String icon = "";
  List<LiveItem> lives = [];
  LivePartition.fromJson(Map<String, dynamic> jsondata) {
    id = jsondata["partition"]["id"];
    name = jsondata["partition"]["name"];
    icon = jsondata["partition"]["sub_icon"]["icon"];
    for (Map<String, dynamic> i in jsondata["lives"]) {
      lives.add(LiveItem.fromJson(i));
    }
  }
}

class LiveItem {
  String id = "";
  int roomid = 0;
  int uid = 0;
  String title = "";
  String uname = "";
  String user_cover = "";
  String system_cover = "";
  String face = "";
  String area_name = "";
  String parent_name = "";
  int online = 0;
  LiveItem({
    required this.roomid,
    required this.uid,
    required this.title,
    required this.uname,
    required this.user_cover,
    required this.area_name,
    required this.face,
    required this.online,
    required this.parent_name,
    required this.system_cover,
  });
  LiveItem.fromJson(Map<String, dynamic> jsondata) {
    roomid = 391199; //jsondata["roomid"];
    uid = jsondata["uid"];
    title = jsondata["title"];
    uname = jsondata["uname"];
    user_cover = jsondata["user_cover"];
    system_cover = jsondata["system_cover"];
    face = jsondata["face"];
    area_name = jsondata["area_name"];
    parent_name = jsondata["parent_name"];
    online = jsondata["online"];
    id = MyMath.getrandomhash();
  }
}

class AreaCard {
  List<AreaItem> list;
  AreaCard(this.list);
}

class AreaItem {
  String cover;
  String title;
  AreaItem(this.cover, this.title);
}
