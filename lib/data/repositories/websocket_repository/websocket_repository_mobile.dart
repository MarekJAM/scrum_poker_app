import 'dart:io';

import 'package:web_socket_channel/io.dart';

import '../repositories.dart';
import '../../models/outgoing_message.dart';
import '../../../utils/session_data_singleton.dart';

class WebSocketRepositoryMobile extends WebSocketRepository {
  WebSocketRepositoryMobile() : super.protected();

  @override
  Future<IOWebSocketChannel> establishConnection(String url) async {
    return IOWebSocketChannel(
      await WebSocket.connect(url.toString()).timeout(Duration(seconds: 5))
        ..add(OutgoingMessage.createWebSocketTokenMessage(
            SessionDataSingleton().getToken()))
        ..pingInterval = Duration(seconds: 10),
    );
  }
}

WebSocketRepository getWebSocketRepository() => WebSocketRepositoryMobile();
