import 'dart:convert';

class OutgoingMessage {
  static String createWebSocketTokenMessage(String token) {
    return json.encode({"token": token});
  }

  static String createLoginMessage(String username, String password) {
    return json.encode({"username": username, "password": password});
  }

  static String createLoginAsGuestMessage(String username) {
    return json.encode({"username": username});
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
