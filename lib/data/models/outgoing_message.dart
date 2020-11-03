import 'dart:convert';

class OutgoingMessage {
  static String createLoginMessage(String username, String password) {
    return json.encode({"username": username, "password": password});
  }

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

  static String createEstimateJsonMsg(int estimate) {
    return json.encode({"estimate": estimate});
  }
}
