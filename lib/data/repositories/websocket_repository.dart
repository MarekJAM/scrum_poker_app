import 'dart:io';
import 'package:web_socket_channel/io.dart';

class WebSocketRepository {

  Future<IOWebSocketChannel> establishConnection(String url) async {
    return IOWebSocketChannel(await WebSocket.connect(url.toString()));
  }
  
}