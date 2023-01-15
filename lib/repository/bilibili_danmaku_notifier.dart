import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:yaml/yaml.dart';

class BiliBiliDanmakuNotifier extends StateNotifier<List<dynamic>> {
  late Timer timer;
  late IOWebSocketChannel _channel;
  int totleTime = 0;
  int roomId;
  final dio = new Dio();
  final url =
      "https://drive.google.com/uc?id=1UwZZ9wjS9DOlqMrmf500G05w8eoE86Za";
  List<RegExp> _supressRegExps = [];
  Future<String> _getWordsYaml() async {
    return rootBundle.loadString('assets/成员list.yaml');
  }

  void _supressWords() {
    _supressRegExps.clear();
    _getWordsYaml().then((data) {
      if (data.isNotEmpty) {
        try {
          var doc = loadYaml(data) as YamlMap;
          final map =
              doc.map((key, value) => MapEntry<String, dynamic>(key, value));
          if (map.containsKey("members")) {
            var regs = ((map["members"] as YamlList).toList().cast<String>())
                .map((element) {
              return new RegExp(r"^(" + RegExp.escape(element) + r"[ ]?)+$");
            });
            _supressRegExps.addAll(regs);
          }
          if (map.containsKey("others")) {
            var regs = ((map["others"] as YamlList).toList().cast<String>())
                .map((element) {
              return new RegExp(r"^(" + RegExp.escape(element) + r"[ ]?)+$");
            });
            _supressRegExps.addAll(regs);
          }
        } catch (e) {
          print("yaml error" + e.toString());
        }
      }
    });
  }

  BiliBiliDanmakuNotifier({required this.roomId}) : super([]) {
    _supressWords();
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 70), (callback) {
      totleTime += 70;
      //sendXinTiaoBao();
      print("i时间: $totleTime s");
      _channel.sink.close(status.goingAway);
      initLive();
    });
    initLive();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    _channel.sink.close(status.goingAway);
  }

  void _addMessages(List<dynamic> data) {
    var msgs = data;
    if (data is List<LiveDanmakuItem>) {
      msgs = (data as List<LiveDanmakuItem>)
          .where((x) => !_supressRegExps.any((reg) => reg.hasMatch(x.msg)))
          .toList();
    }
    state = msgs;
  }

  //初始化
  void initLive() {
    try {
      _channel = IOWebSocketChannel.connect(
          "wss://broadcastlv.chat.bilibili.com:2245/sub",
          headers: {
            "Host": "broadcastlv.chat.bilibili.com:2245",
            "Sec-WebSocket-Version": " 13",
            "Connection": " Upgrade",
          });
      joinRoom(roomId);
      setListener();
    } catch (e) {
      print("WebSocket Connection Error: $e");
    }
  }

  void sendXinTiaoBao() {
    List<int> code = [0, 0, 0, 16, 0, 16, 0, 1, 0, 0, 0, 2, 0, 0, 0, 1];
    _channel.sink.add(Uint8List.fromList(code).buffer);
  }

  //加入房间
  void joinRoom(int id) {
    String msg = "{\"roomid\":$id}";
    _channel.sink.add(encode(7, msg: msg));
  }

  //设置监听
  void setListener() {
    _channel.stream.listen((msg) {
      Uint8List list = Uint8List.fromList(msg);
      decode(list);
    });
  }

  //对消息编码
  Uint8List encode(int op, {String? msg}) {
    List<int> header = [0, 0, 0, 0, 0, 16, 0, 1, 0, 0, 0, op, 0, 0, 0, 1];
    if (msg != null) {
      List<int> msgCode = utf8.encode(msg);
      header.addAll(msgCode);
    }
    Uint8List uint8list = Uint8List.fromList(header);
    uint8list = writeInt(uint8list, 0, 4, header.length);
    print(uint8list.toString());
    return uint8list;
  }

  //对消息进行解码
  decode(Uint8List list) {
    //int packLen = readInt(list, 0, 4);
    int headerLen = readInt(list, 4, 2);
    int op = readInt(list, 8, 4);
/*
0普通包正文不使用压缩
1心跳及认证包正文不使用压缩
2普通包正文使用zlib压缩
3普通包正文使用brotli压缩,解压为一个带头部的协议0普通包
https://github.com/SocialSisterYi/bilibili-API-collect/blob/89564e96bbbcd04f0fcc7a609a7721fe6da89d24/live/message_stream.md
 */
    int ver = readInt(list, 6, 2);

    print("接收到：");
    print("listLen ${list.length}");
    //print("packLen $packLen");
    print("headerLen $headerLen");
    print("op $op");
    switch (op) {
      case 8:
        print("进入房间");
        break;
      case 5:
        int offset = 0;
        while (offset < list.length) {
          /*
          packLen = readInt(list, offset + 0, 4);
          headerLen = 16;
          Uint8List body = list.sublist(offset + headerLen, offset + packLen);
          */
          String data = "";
          int packLen = readInt(list, offset + 0, 4);
          int headerLen = readInt(list, offset + 4, 2);
          //print("packLen: $packLen");
          //print("headerLen: $headerLen");
          var a = list.length;
          //print("list.len: $a");
          //print("ver: $ver");
          if (ver == 2) {
            //print("offset: $offset");
            Uint8List body = list.sublist(offset + headerLen, offset + packLen);
            var v = zlib.decode(body);
            data = Utf8Decoder(allowMalformed: true).convert(v);
          } else {
            Uint8List body = list.sublist(offset + headerLen, offset + packLen);
            data = Utf8Decoder(allowMalformed: true).convert(body);
          }
          /*
          try {
            var v = zlib.decode(body);
            //data = utf8.decode(v);
            data = Utf8Decoder(allowMalformed: true).convert(v);
          } catch (e, s) {
            try {
              data = Utf8Decoder(allowMalformed: true).convert(body);
            } catch (e, s) {
              return;
            }
          }
           */
          List<Map<String, dynamic>> jds =
              List<Map<String, dynamic>>.empty(growable: true);
          offset += packLen;
          data.split(RegExp(r"[\x00-\x1f]+")).forEach((element) {
            try {
              var parsedItem = json.decode(element);
              if (parsedItem is Map<String, dynamic>) {
                jds.add(parsedItem);
              }
            } catch (e, s) {
              //print(e);
            }
          });
          List<LiveDanmakuItem> danmakus =
              List<LiveDanmakuItem>.empty(growable: true);
          jds.forEach((jd) {
            switch (jd["cmd"]) {
              case "DANMU_MSG":
                String msg = jd["info"][1].toString();
                String name = jd["info"][2][1].toString();
                int dm_type =
                    json.decode(jd["info"][0][15]["extra"])["dm_type"];
                //ignore emotion
                if (dm_type == 0) {
                  print("$name 说： $msg");
                  //addDanmaku(LiveDanmakuItem.fromInfo(jd["info"]));
                  danmakus.add(LiveDanmakuItem.fromInfo(jd["info"]));
                  //addDanmaku(LiveDanmakuItem(name, msg));
                }
                break;
              case "SEND_GIFT":
                String name = jd["data"]["uname"].toString();
                String action = jd["data"]["action"].toString();
                String msg = jd["data"]["giftName"].toString();
                int count = jd["data"]["num"];
                //print("$name $action $count 个 $msg");
                //addGift(GiftItem(name, action, count, msg));
                break;
              default:
              //print(jd["cmd"]);
            }
          });
          _addMessages(danmakus);
        }
        break;
      case 3:
        int people = readInt(list, headerLen, 4);
        print("人气: $people");
        break;
      default:
    }
  }

  //写入编码
  Uint8List writeInt(Uint8List src, int start, int len, int value) {
    int i = 0;
    while (i < len) {
      src[start + i] = value ~/ pow(256, len - i - 1);
      i++;
    }
    return src;
  }

  //从编码读出数字
  int readInt(Uint8List src, int start, int len) {
    int res = 0;
    for (int i = len - 1; i >= 0; i--) {
      res += (pow(256, len - i - 1) * src[start + i]).toInt();
    }
    return res;
  }
}

class DanmakuPackage {
  int op = 0;
  dynamic body;
}

//https://github.com/pierpan2/VTSBiliWF/blob/aec60ab3f0c1e44fc74c10b4c4def1f48069390c/VTSBiliWF/bin/Debug/netcoreapp3.1/py/blivedm.py
class LiveDanmakuItem {
  int font_size;
  int color;
  String name;
  String msg;
  int timestamp;
  LiveDanmakuItem(this.name, this.msg, this.timestamp,
      {this.font_size = 0, this.color = 0});
  LiveDanmakuItem.fromInfo(List<dynamic> info)
      : this.name = info[2][1].toString(),
        this.msg = info[1].toString(),
        this.timestamp = info[0][4],
        this.font_size = info[0][2],
        this.color = info[0][3] {}

  bool operator ==(dynamic other) {
    if (other is LiveDanmakuItem) {
      var f1 = this.name == other.name;
      var f2 = this.msg == other.msg;
      var f3 = this.timestamp == other.timestamp;
      return f1 && f2 && f3;
    } else {
      return false;
    }
  }
}

class GiftItem {
  String name;
  String msg;
  String action;
  int count;
  GiftItem(
    this.name,
    this.action,
    this.count,
    this.msg,
  );
}
