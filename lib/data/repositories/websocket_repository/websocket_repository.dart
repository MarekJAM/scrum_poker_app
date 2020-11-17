import 'dart:convert';

import 'weboscket_repository_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'websocket_repository_mobile.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'websocket_repository_web.dart';

import '../../models/models.dart';

abstract class WebSocketRepository {
  factory WebSocketRepository() => getWebSocketRepository();

  WebSocketRepository.protected();

  establishConnection(String url) {}

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
