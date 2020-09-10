import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginConnectingToServer extends LoginState {
  @override
  String toString() => 'LoginConnectingToServer';
}

class LoginConnectedToServer extends LoginState {
  final String message;

  const LoginConnectedToServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'LoginConnectedToServer $message';
}

class LoginDisconnectedFromServer extends LoginState {
  final String message;
  final String username;
  final String serverAddress;

  const LoginDisconnectedFromServer({@required this.message, @required this.username, @required this.serverAddress}) : assert(message != null), assert(username != null), assert(serverAddress != null);

  @override
  String toString() => 'LoginDisconnectedFromServer $message';
}

class LoginConnectionError extends LoginState {
  final String message;

  const LoginConnectionError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'LoginConnectionError $message';
}
