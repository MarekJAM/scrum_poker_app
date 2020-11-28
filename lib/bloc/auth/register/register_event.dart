part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSignUpE extends RegisterEvent {
  final String serverAddress;
  final String username;
  final String password;

  RegisterSignUpE(this.serverAddress, this.username, this.password);

  @override
  String toString() => 'RegisterSignUpE';
}
