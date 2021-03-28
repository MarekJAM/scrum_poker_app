// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:web_socket_channel/html.dart';

import '../repositories.dart';
import '../../models/outgoing_message.dart';
import '../../../utils/session_data_singleton.dart';

class WebSocketRepositoryWeb extends WebSocketRepository {
  WebSocketRepositoryWeb() : super.protected();

  @override
  Future<HtmlWebSocketChannel> establishConnection(String url) async {
    WebSocket ws = WebSocket(url);
    ws.onOpen
      ..listen((_) {
        ws.send(OutgoingMessage.createWebSocketTokenMessage(SessionDataSingleton().getToken()));
      })
      ..timeout(Duration(seconds: 5));
    return HtmlWebSocketChannel(ws);
  }
}

WebSocketRepository getWebSocketRepository() => WebSocketRepositoryWeb();
