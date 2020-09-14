import 'dart:convert';
import 'dart:io';
import '../models/models.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketRepository {

  Future<IOWebSocketChannel> establishConnection(String url) async {
    return IOWebSocketChannel(await WebSocket.connect(url.toString()).timeout(Duration(seconds: 5))..pingInterval = Duration(seconds: 10));
  }

  dynamic parseMessage(dynamic message) {
    final decodedMessage = json.decode(message);
    dynamic obj;
    if (decodedMessage.containsKey("lobby_status")) {
      obj = LobbyStatus.fromJson(decodedMessage);
    } else if (decodedMessage.containsKey("room_status")) {
      obj = RoomStatus.fromJson(decodedMessage);
    } 
    return obj;
  }
}