import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class WebSocketState extends Equatable {
  const WebSocketState();

  @override
  List<Object> get props => [];
}

class WebSocketInitial extends WebSocketState {
  @override
  String toString() => 'WebSocketInitial';
}

class WSConnectingToServer extends WebSocketState {
  @override
  String toString() => 'ConnectingToServer';
}

class WSConnectedToServer extends WebSocketState {
  final String message;

  const WSConnectedToServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'ConnectedToServer $message';
}

class WSDisconnectedFromServer extends WebSocketState {
  final String message;

  const WSDisconnectedFromServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'DisconnectedFromServer $message';
}

class WSConnectionError extends WebSocketState {
  final String message;

  const WSConnectionError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'DisconnectedFromServer $message';
}

class WSMessageLoading extends WebSocketState {
  @override
  String toString() => 'MessageLoading';
}

class WSMessageLoaded extends WebSocketState {
  final String message;

  const WSMessageLoaded({@required this.message}) : assert(message != null);

  @override
  String toString() => 'MessageLoaded: $message';
}