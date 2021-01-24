part of 'recovery_bloc.dart';

abstract class RecoveryEvent extends Equatable {
  const RecoveryEvent();

  @override
  List<Object> get props => [];
}

class RecoveryStart extends RecoveryEvent {
  final String username;

  RecoveryStart({@required this.username});

  @override
  String toString() => 'RecoveryStart: $username';
}

class RecoverySendAnswer extends RecoveryEvent {
  final String answer;

  RecoverySendAnswer({@required this.answer});

  @override
  String toString() => 'RecoveryStart: $answer';
}
