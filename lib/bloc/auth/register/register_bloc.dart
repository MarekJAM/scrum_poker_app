import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  RegisterBloc({@required authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(RegisterInitial()) {
    on<RegisterSignUpE>(_onRegisterSignUpE);
  }

  void _onRegisterSignUpE(RegisterSignUpE event, Emitter<RegisterState> emit) async {
    emit(RegisterSigningUp());
    
    try {
      await _authRepository.register(
        event.username,
        event.password,
        event.securityQuestion,
        event.answer,
      );

      emit(RegisterSignedUp());
    } on SocketException catch (e) {
      print(e);
      emit(RegisterSignUpError(message: "Could not establish connection with server."));
    } catch (e) {
      print(e);
      emit(RegisterSignUpError(message: e.message));
    }
  }
}
