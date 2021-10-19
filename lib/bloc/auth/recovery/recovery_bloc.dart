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
        super(RecoveryInitial()) {
          on<RecoveryStart>(_onRecoveryStart);
          on<RecoverySendAnswer>(_onRecoverySendAnswer);
          on<RecoverySendPassword>(_onRecoverySendPassword);
        }

  void _onRecoveryStart(RecoveryStart event, Emitter<RecoveryState> emit) async {
    emit(RecoveryLoading());

    try {
      var response = await _authRepository.recoverStepOne(event.username);

      token = response.token;

      emit(RecoveryStepOneDone(response.securityQuestion));
    } catch (e) {
      print(e);
      emit(RecoveryError(message: e.message ?? "Something went wrong."));
    }
  }

  void _onRecoverySendAnswer(
      RecoverySendAnswer event, Emitter<RecoveryState> emit) async {
    emit(RecoveryLoading());

    try {
      token = await _authRepository.recoverStepTwo(event.answer, token);

      emit(RecoveryStepTwoDone());
    } catch (e) {
      print(e);
      emit(RecoveryError(message: e.message ?? "Something went wrong."));
    }
  }

  void _onRecoverySendPassword(
      RecoverySendPassword event, Emitter<RecoveryState> emit) async {
    print(token);
    emit(RecoveryLoading());

    try {
      await _authRepository.recoverStepThree(event.password, token);

      emit(RecoveryStepThreeDone());
    } catch (e) {
      print(e);
      emit(RecoveryError(message: e.message ?? "Something went wrong."));
    }
  }
}
