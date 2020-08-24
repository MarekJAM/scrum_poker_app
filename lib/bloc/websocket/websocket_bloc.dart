import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/data/repositories/websocket_repository.dart';
import 'package:web_socket_channel/io.dart';
import 'bloc.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketRepository webSocketRepository;
  IOWebSocketChannel channel;

  WebSocketBloc({@required this.channel, @required this.webSocketRepository}) : super(WebSocketInitial());

  @override
  Stream<WebSocketState> mapEventToState(WebSocketEvent event) async* {
    if (event is WSConnectToServerE) {
      yield* _mapConnectToServerToState(event);
    } else if (event is WSConnectionErrorReceivedE) {
      yield* _mapConnectionErrorReceivedToState(event);
    } else if (event is WSMessageReceivedE) {
      yield* _mapMessageRecievedToState(event);
    } else if (event is WSSendMessageE) {
      yield* _mapSendMessageToState(event);
    } else if (event is WSDisconnectFromServerE) {
      yield* _mapDisconnectFromServerToState(event);
    }
  }

  Stream<WebSocketState> _mapConnectToServerToState(event) async* {
    yield WSConnectingToServer();
    try {
      channel = await webSocketRepository.establishConnection(event.link);
      channel.stream.listen((message) {
        print(message);
        add(WSMessageReceivedE(webSocketRepository.parseMessage(message)));
      }, onError: (e) {
        print(e);
        add(WSConnectionErrorReceivedE("Could not establish connection."));
      }, onDone: () {
        add(WSDisconnectFromServerE());
      });
      yield WSConnectedToServer(message: "Connected to server");
    } catch (e) {
      print(e);
      yield WSConnectionError(message: "Could not establish connection.");
    }
  }

  Stream<WebSocketState> _mapConnectionErrorReceivedToState(event) async* {
    try {
      yield WSConnectionError(message: event.message);
    } catch (e) {
      print(e);
    }
  }

  Stream<WebSocketState> _mapDisconnectFromServerToState(event) async* {
    try {
      channel.sink.close();
      yield WSDisconnectedFromServer(message: "Disconnected from server");
    } catch (e) {
      print(e);
    }
  }

  Stream<WebSocketState> _mapSendMessageToState(event) async* {
    try {
      channel.sink.add(event.message);
    } catch (e) {
      print(e);
    }
  }

  Stream<WebSocketState> _mapMessageRecievedToState(event) async* {
    yield WSMessageLoading();
    try {
      yield WSMessageLoaded(message: event.message);
    } catch (e) {
      print(e);
    }
  }

  
}
