import 'dart:convert';

class OutgoingMessage {
  static String createCreateRoomJsonMsg(String username, String roomName) {
    return json.encode({"username": username, "roomname": roomName});
  }

  static String createConnectRoomJsonMsg(String username, String roomName) {
    return json.encode({"username": username, "roomname": roomName});
  }

  static String createDisconnectFromRoomJsonMsg(String username) {
    return json.encode({"username": username});
  }

  static String createRequestEstimateJsonMsg(String taskNumber) {
    return json.encode({"request_estimate": taskNumber});
  }
}
