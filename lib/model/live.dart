// TAB页面中的其中一个页面，其他类似
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sibatv/model/live_info.dart';

class Live extends ChangeNotifier {
  final _valueController = StreamController<List<LiveData>>.broadcast();
  final bool inLive;
  bool _requested = false;
  Live({required this.inLive});
  Stream<List<LiveData>> get value => _valueController.stream;

  void reBroadCastStream() {
    if (_liveDatas.length == 0) {
      requestLiveList();
      return;
    }
    _valueController.sink.add(_liveDatas);
  }

  void dispose() {
    _valueController.close();
  }

  final List<LiveData> _liveDatas = <LiveData>[];
  void _liveData(LiveData datas) {
    for (var data in datas.content.liveList) {}
    _liveDatas.add(datas);
    _valueController.sink.add(_liveDatas);
  }

  Future<LiveRoomInfo> requestLiveRoomInfo(String id) {
    final url =
        Uri.parse('https://pocketapi.48.cn/live/api/v1/live/getLiveOne');
    return http
        .post(url,
            headers: createHeaders(), body: json.encode({'liveId': '${id}'}))
        .then((response) {
      if (response.statusCode != 200) {
        throw Exception('Something occurred.');
      }
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return LiveRoomInfo.fromJson(json.decode(response.body));
    });
  }

  /*
  * groupId:
  *   明星殿堂：19
  *   THE9：17
  *   硬糖少女303：18
  *   丝芭影视：20
  *   SNH48：10
  *   BEJ48：11
  *   GNZ48：12
  *   CKG48：14
  *   IDFT：15
  *   海外练习生：16
  */
  void requestLiveList(
      {String next = '0', String? groupId, String? userId}) async {
    if (_requested) return;
    _requested = true;
    var body = {"debug": true, "next": next};
    if (inLive) {
      body['groupId'] = 0;
      body['record'] = false;
    }
    if (userId != null) body['userId'] = userId;
    if (groupId != null) body['groupId'] = groupId;

    final url =
        Uri.parse('https://pocketapi.48.cn/live/api/v1/live/getLiveList');
    final res = await http
        .post(url, headers: createHeaders(), body: json.encode(body))
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode != 200) {
        _requested = false;
        throw Exception('Something occurred.');
      }
      _liveData(LiveData.fromJson(json.decode(response.body)));
      _requested = false;
    }).onError((error, stackTrace) {
      print("error: ${error}");
      _requested = false;
    });
    print("res: ${res}");

    //_liveData(LiveData.fromJson(testjson));
    return;
  }

  Map<String, String> createHeaders() {
    return {
      'Content-Type': 'application/json;charset=utf-8',
      'appInfo': jsonEncode({
        'vendor': 'apple',
        'deviceId': '${rStr(8)}-${rStr(4)}-${rStr(4)}-${rStr(4)}-${rStr(12)}',
        'appVersion': '6.2.2',
        'appBuild': '21080401',
        'osVersion': '11.4.1',
        'osType': 'ios',
        'deviceName': 'iPhone XR',
        'os': 'ios'
      }),
      'User-Agent': 'PocketFans201807/6.0.16 (iPhone; iOS 13.5.1; Scale/2.00)',
      'Accept-Language': 'zh-Hans-AW;q=1',
      'Host': 'pocketapi.48.cn'
    };
  }

  String rStr(int len) {
    const str = 'QWERTYUIOPASDFGHJKLZXCVBNM1234567890';
    var result = '';

    for (int i = 0; i < len; i++) {
      var rIndex = Random().nextInt(str.length);
      result += str[rIndex];
    }
    return result;
  }
}
