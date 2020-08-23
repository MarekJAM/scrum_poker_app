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
  String toString() => 'WSConnectingToServer';
}

class WSConnectedToServer extends WebSocketState {
  final String message;

  const WSConnectedToServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'WSConnectedToServer $message';
}

class WSDisconnectedFromServer extends WebSocketState {
  final String message;

  const WSDisconnectedFromServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'WSDisconnectedFromServer $message';
}

class WSConnectionError extends WebSocketState {
  final String message;

  const WSConnectionError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'WSConnectionError $message';
}

class WSMessageLoading extends WebSocketState {
  @override
  String toString() => 'WSMessageLoading';
}

class WSMessageLoaded extends WebSocketState {
  final dynamic message;

  const WSMessageLoaded({@required this.message}) : assert(message != null);

  @override
  String toString() => 'WSMessageLoaded: $message';
}