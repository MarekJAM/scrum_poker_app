import 'dart:convert';

class OutgoingMessage {
  static String createLoginMessage(String username, String password) {
    return json.encode({"username": username, "password": password});
  }

  static String createCreateRoomJsonMsg(String roomName) {
    return json.encode({"roomname": roomName});
  }

  static String createConnectRoomJsonMsg(String roomName) {
    return json.encode({"roomname": roomName});
  }

  static String createRequestEstimateJsonMsg(String taskNumber) {
    return json.encode({"request_estimate": taskNumber});
  }

  static String createEstimateJsonMsg(int estimate) {
    return json.encode({"estimate": estimate});
  }
}
