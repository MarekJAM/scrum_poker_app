part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends LoginEvent {
  @override
  String toString() => 'AppStarted';
}

class LoginConnectToServerE extends LoginEvent {
  final String serverAddress;
  final String username;
  final String password;
  final bool isLoggingAsGuest;

  LoginConnectToServerE({@required this.serverAddress, @required this.username, this.password, this.isLoggingAsGuest = false});

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

