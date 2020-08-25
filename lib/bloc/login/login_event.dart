import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginConnectToServerE extends LoginEvent {
  final String link;
  final String username;

  LoginConnectToServerE(this.link, this.username);

  @override
  String toString() => 'LoginConnectToServerE';
}

class LoginConnectedToServerE extends LoginEvent {
  @override
  String toString() => 'LoginConnectedToServerE';
}

class LoginConnectionErrorReceivedE extends LoginEvent {
  final String message;

  LoginConnectionErrorReceivedE(this.message);

  @override
  String toString() => 'LoginConnectionErrorReceivedE: $message';
}

class LoginSendMessageE extends LoginEvent {
  final String message;

  LoginSendMessageE(this.message);

  @override
  String toString() => 'LoginSendMessageE';
}

class LoginMessageReceivedE extends LoginEvent {
  final String message;

  LoginMessageReceivedE(this.message);

  @override
  String toString() => 'LoginMessageReceivedE: $message';
}

class LoginDisconnectFromServerE extends LoginEvent {
  @override
  String toString() => 'LoginDisconnectFromServerE';
}

class LoginDisconnectedFromServerE extends LoginEvent {
  final String message;

  LoginDisconnectedFromServerE(this.message);

  @override
  String toString() => 'LoginDisconnectedFromServerE';
}

