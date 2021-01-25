import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

part 'recovery_event.dart';
part 'recovery_state.dart';

class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  final AuthRepository _authRepository;
  String token;

  RecoveryBloc({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(RecoveryInitial());

  @override
  Stream<RecoveryState> mapEventToState(
    RecoveryEvent event,
  ) async* {
    if (event is RecoveryStart) {
      yield* _mapRecoveryStartToState(event);
    } else if (event is RecoverySendAnswer) {
      yield* _mapRecoverySendAnswerToState(event);
    }
  }

  Stream<RecoveryState> _mapRecoveryStartToState(RecoveryStart event) async* {
    yield RecoveryLoading();

    try {
      var response = await _authRepository.recoverStepOne(event.username);

      token = response.token;

      yield RecoveryStepOneDone(response.securityQuestion);
    } catch (e) {
      print(e);
      yield RecoveryError(message: e.message ?? "Something went wrong.");
    }
  }

  Stream<RecoveryState> _mapRecoverySendAnswerToState(
      RecoverySendAnswer event) async* {
    yield RecoveryLoading();

    try {
      token = await _authRepository.recoverStepTwo(event.answer, token);

      yield RecoveryStepTwoDone();
    } catch (e) {
      print(e);
      yield RecoveryError(message: e.message ?? "Something went wrong.");
    }
  }
}
