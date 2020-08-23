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
  String toString() => 'WSConnectToServerE';
}

class WSConnectionErrorReceivedE extends WebSocketEvent {
  final String message;

  WSConnectionErrorReceivedE(this.message);

  @override
  String toString() => 'WSConnectionErrorReceivedE: $message';
}

class WSSendMessageE extends WebSocketEvent {
  final String message;

  WSSendMessageE(this.message);

  @override
  String toString() => 'WSSendMessageE';
}

class WSMessageReceivedE extends WebSocketEvent {
  final dynamic message;

  WSMessageReceivedE(this.message);

  @override
  String toString() => 'WSMessageReceivedE: $message';
}

class WSDisconnectFromServerE extends WebSocketEvent {
  @override
  String toString() => 'WSDisconnectFromServerE';
}

