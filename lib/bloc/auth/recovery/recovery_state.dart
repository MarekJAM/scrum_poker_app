part of 'recovery_bloc.dart';

abstract class RecoveryState extends Equatable {
  const RecoveryState();

  @override
  List<Object> get props => [];
}

class RecoveryInitial extends RecoveryState {}

class RecoveryLoading extends RecoveryState {
  @override
  String toString() => 'RecoveryLoading';
}

class RecoveryStepOneDone extends RecoveryState {
  final String question;

  RecoveryStepOneDone(this.question);

  @override
  String toString() => 'RecoveryStepOneDone';
}

class RecoveryStepTwoDone extends RecoveryState {
  @override
  String toString() => 'RecoveryStepTwoDone';
}

class RecoveryError extends RecoveryState {
  final String message;

  RecoveryError({@required this.message});

  @override
  String toString() => 'RecoveryError';
}
