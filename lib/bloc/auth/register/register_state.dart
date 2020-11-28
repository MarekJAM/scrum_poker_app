part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  @override
  String toString() => 'RegisterInitial';
}

class RegisterSigningUp extends RegisterState {
  @override
  String toString() => 'RegisterSigningUp';
}

class RegisterSignedUp extends RegisterState {
  @override
  String toString() => 'RegisterSignedUp';
}

class RegisterSignUpError extends RegisterState {
  final String message;

  const RegisterSignUpError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'RegisterSignUpError';
}
