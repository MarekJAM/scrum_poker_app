import 'package:equatable/equatable.dart';

abstract class WebSocketEvent extends Equatable {
  const WebSocketEvent();

  @override
  List<Object> get props => [];
}

class WSConnectToServerE extends WebSocketEvent {
  final String link;

  WSConnectToServerE(this.link);

  @override
  String toString() => 'ConnectToServer';
}

class WSConnectionErrorReceivedE extends WebSocketEvent {
  final String message;

  WSConnectionErrorReceivedE(this.message);

  @override
  String toString() => 'Connection error: $message';
}

class WSSendMessageE extends WebSocketEvent {
  final String message;

  WSSendMessageE(this.message);

  @override
  String toString() => 'SendMessage';
}

class WSMessageReceivedE extends WebSocketEvent {
  final String message;

  WSMessageReceivedE(this.message);

  @override
  String toString() => 'Message recieved: $message';
}

class WSDisconnectFromServerE extends WebSocketEvent {
  final String message;

  WSDisconnectFromServerE(this.message);

  @override
  String toString() => 'Disconnect from server: $message';
}

