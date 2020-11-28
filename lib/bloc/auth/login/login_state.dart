part of 'login_bloc.dart';

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

  const LoginDisconnectedFromServer({@required this.serverAddress, this.message = "", this.username = ""}) : assert(message != null);

  @override
  String toString() => 'LoginDisconnectedFromServer $message';
}

class LoginConnectionError extends LoginState {
  final String message;

  const LoginConnectionError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'LoginConnectionError $message';
}
