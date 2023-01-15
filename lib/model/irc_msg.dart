import 'dart:convert';
import 'dart:core';
import 'dart:io';

class IrcMsg {
  Duration time = Duration();
  String nickName = "";
  String msg = "";
  IrcMsg({
    required this.time,
    required this.nickName,
    required this.msg,
  });
  IrcMsg.fromLine(List<String?> parsed) {
    time = parsed[0] != null ? parseTime("${parsed[0]}000") : Duration();
    nickName = parsed[1] ?? "";
    msg = parsed[2] ?? "";
  }

  Duration parseTime(String input) {
    final parts = input.split(':');

    if (parts.length != 3) throw FormatException('Invalid time format');

    int days;
    int hours;
    int minutes;
    int seconds;
    int milliseconds;
    int microseconds;

    {
      final p = parts[2].split('.');

      if (p.length != 2) throw FormatException('Invalid time format');

      final p2 = int.parse(p[1]);
      microseconds = p2 % 1000;
      milliseconds = p2 ~/ 1000;

      seconds = int.parse(p[0]);
    }

    minutes = int.parse(parts[1]);

    {
      int p = int.parse(parts[0]);
      hours = p % 24;
      days = p ~/ 24;
    }

    // TODO verify that there are no negative parts

    return Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds);
  }

  static List<String?> parseLine(String line) {
    RegExpMatch? match = RegExp(r'\[([0-9:.]*)\](.*)\t(.*)').firstMatch(line);
    if (match != null && match.groupCount == 3) {
      return [match.group(1), match.group(2), match.group(3)];
    }
    return [];
  }

  static List<IrcMsg> getIrcMessages(String msgFile) {
    List<IrcMsg> msgs = List<IrcMsg>.empty(growable: true);

    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse(msgFile)).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.transform(utf8.decoder).transform(const LineSplitter()) //行に分ける
          .listen((data) {
        var v = parseLine(data);
        if (v.isNotEmpty) {
          msgs.add(IrcMsg.fromLine(v));
        }
      });
    });

    return msgs;
  }
}
