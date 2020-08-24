import 'dart:convert';
import 'dart:io';
import '../models/models.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketRepository {

  Future<IOWebSocketChannel> establishConnection(String url) async {
    return IOWebSocketChannel(await WebSocket.connect(url.toString()));
  }

  dynamic parseMessage(dynamic message) {
    final decodedMessage = json.decode(message);
    if (decodedMessage.containsKey("rooms")) {
      final obj = Rooms.fromJson(decodedMessage);
      return obj;
    } else if (decodedMessage.containsKey("roomies")) {
      final obj = Roomies.fromJson(decodedMessage);
      return obj;
    }
  }
}