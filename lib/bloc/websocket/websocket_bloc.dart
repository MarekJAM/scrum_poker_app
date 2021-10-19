import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../data/repositories/websocket_repository/websocket_repository.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketRepository webSocketRepository;
  WebSocketChannel channel;

  final intentionalCloseCode = 4999;

  WebSocketBloc({@required this.channel, @required this.webSocketRepository}) : super(WebSocketInitial()) {
    on<WSConnectToServerE>(_onConnectToServer);
    on<WSConnectionErrorReceivedE>(_onConnectionErrorReceived);
    on<WSDisconnectFromServerE>(_onDisconnectFromServer);
    on<WSDisconnectedFromServerE>(_onDisconnectedFromServer);
    on<WSSendMessageE>(_onSendMessage);
    on<WSMessageReceivedE>(_onMessageRecieved);
  }

  void _onConnectToServer(WSConnectToServerE event, Emitter<WebSocketState> emit) async {
    emit(WSConnectingToServer());
    try {
      channel = await webSocketRepository.establishConnection(event.link);
      channel.stream.listen((message) {
        add(WSMessageReceivedE(webSocketRepository.parseMessage(message)));
      }, onError: (e) {
        print(e);
        add(WSConnectionErrorReceivedE("Could not establish connection."));
      }, onDone: () {
        var message = channel.closeCode == intentionalCloseCode ? "" : "Disconnected. Check your internet connection";

        add(WSDisconnectedFromServerE(message: message));
      });
      emit(WSConnectedToServer(message: "Connected to server"));
    } catch (e) {
      print(e);
      emit(WSConnectionError(message: "Could not establish connection."));
    }
  }

  void _onConnectionErrorReceived(WSConnectionErrorReceivedE event, Emitter<WebSocketState> emit) async {
    try {
      emit(WSConnectionError(message: event.message));
    } catch (e) {
      print(e);
    }
  }

  void _onDisconnectFromServer(WSDisconnectFromServerE event, Emitter<WebSocketState> emit) async {
    try {
      //sending closeCode to distinguish whether user disconnected intentionally or not
      channel.sink.close(intentionalCloseCode);
    } catch (e) {
      print(e);
    }
  }

  void _onDisconnectedFromServer(WSDisconnectedFromServerE event, Emitter<WebSocketState> emit) async {
    try {
      emit(WSDisconnectedFromServer(message: event.message));
    } catch (e) {
      print(e);
    }
  }

  void _onSendMessage(WSSendMessageE event, Emitter<WebSocketState> emit) async {
    try {
      channel.sink.add(event.message);
    } catch (e) {
      print(e);
    }
  }

  void _onMessageRecieved(WSMessageReceivedE event, Emitter<WebSocketState> emit) async {
    emit(WSMessageLoading());
    try {
      emit(WSMessageLoaded(message: event.message));
    } catch (e) {
      print(e);
    }
  }
}
