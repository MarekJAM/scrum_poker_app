import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../utils/session_data_singleton.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  RegisterBloc({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterSignUpE) {
      yield* _mapRegisterSignUpEToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterSignUpEToState(
      RegisterSignUpE event) async* {
    yield RegisterSigningUp();
    try {
      await SessionDataSingleton().setServerAddress(event.serverAddress);

      await _authRepository.register(event.username, event.password);

      yield RegisterSignedUp();
    } on SocketException catch (e) {
      print(e);
      yield RegisterSignUpError(
          message: "Could not establish connection with server.");
    } catch (e) {
      print(e);
      yield RegisterSignUpError(message: e.message);
    }
  }
}
