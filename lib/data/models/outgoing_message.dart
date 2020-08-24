import 'dart:convert';

class OutgoingMessage {
  static String createConnectRoomJsonMsg(String roomName) {
    return json.encode({"connect_room": roomName});
  }

  static String createCreateRoomJsonMsg(String roomName) {
    return json.encode({"create_room": roomName});
  }

}