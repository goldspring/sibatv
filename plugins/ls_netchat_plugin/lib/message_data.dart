class MsgListResult {
  List<NIMessage> msgList = [];

  List<NIMessage> getResultFromMap(data) {
    msgList = [];
    data.forEach((info) {
      msgList.add(NIMessage()
        ..nicName = info["nicName"]
        ..msgType = info["msgType"]
        ..content = info["content"]
        ..sessionId = info["sessionId"]
        ..messageType = info["messageType"]);
    });

    return msgList;
  }
}

class NIMessage {
  int msgType = 0;
  String nicName = "";
  String content = "";
  String messageType = "";
  String sessionId = "";
}
