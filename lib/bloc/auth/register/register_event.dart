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
  final String securityQuestion;
  final String answer;

  RegisterSignUpE(
    this.serverAddress,
    this.username,
    this.password,
    this.securityQuestion,
    this.answer,
  );

  @override
  String toString() => 'RegisterSignUpE';
}
