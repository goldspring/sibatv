import 'package:intl/intl.dart';

class TimeUtils {
  static String getTime() {
    DateTime dateTime = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy年MM月dd日 HH:mm');
    //return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}';
    return outputFormat.format(dateTime);
  }

  static String getDateFromUnixTime(String ctime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(ctime));
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(dateTime);
  }
}
