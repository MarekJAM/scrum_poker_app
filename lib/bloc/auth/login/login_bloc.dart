import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import '../../websocket/websocket_bloc.dart';
import '../../../data/repositories/repositories.dart';
import '../../../utils/session_data_singleton.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final WebSocketBloc _webSocketBloc;
  final AuthRepository _authRepository;
  StreamSubscription webSocketSubscription;

  LoginBloc({@required WebSocketBloc webSocketBloc, @required authRepository})
      : assert(webSocketBloc != null),
        assert(authRepository != null),
        _webSocketBloc = webSocketBloc,
        _authRepository = authRepository,
        super(LoginInitial()) {
    webSocketSubscription = _webSocketBloc.stream.listen((state) {
      if (state is WSConnectedToServer) {
        add(LoginConnectedToServerE());
      } else if (state is WSDisconnectedFromServer) {
        add(LoginDisconnectedFromServerE(state.message));
      } else if (state is WSConnectionError) {
        add(LoginConnectionErrorReceivedE(state.message));
      }
    });
    on<AppStarted>(_onAppStarted);
    on<LoginConnectToServerE>(_onLoginConnectToServer);
    on<LoginConnectedToServerE>(_onLoginConnectedToServer);
    on<LoginConnectionErrorReceivedE>(_onLoginConnectionErrorReceived);
    on<LoginDisconnectFromServerE>(_onLoginDisconnectFromServer);
    on<LoginDisconnectedFromServerE>(_onLoginDisconnectedFromServer);
  }

  // temporary solution, normally some kind of autologin attempt should be here
  void _onAppStarted(AppStarted event, Emitter<LoginState> emit) async {
    try {
      await SessionDataSingleton().init();
      emit(LoginDisconnectedFromServer(
        username: SessionDataSingleton().getUsername(),
        serverAddress: SessionDataSingleton().getServerAddress(),
      ));
    } catch (e) {
      print(e);
      emit(LoginConnectionError(message: "Connection error occured."));
    }
  }

  void _onLoginConnectToServer(LoginConnectToServerE event, Emitter<LoginState> emit) async {
    emit(LoginConnectingToServer());
    try {
      await SessionDataSingleton().setUsername(event.username);

      event.isLoggingAsGuest
          ? await _authRepository.loginAsGuest(event.username)
          : await _authRepository.loginWithCredentials(
              event.username,
              event.password,
            );

      _webSocketBloc.add(WSConnectToServerE("ws://" + event.serverAddress));
    } on SocketException catch (e) {
      print(e);
      emit(LoginConnectionError(message: "Could not establish connection with server."));
    } catch (e) {
      print(e);
      emit(LoginConnectionError(message: e.message));
    }
  }

  void _onLoginConnectedToServer(LoginConnectedToServerE event, Emitter<LoginState> emit) async {
    try {
      emit(LoginConnectedToServer(message: "Connected to server"));
    } catch (e) {
      print(e);
    }
  }

  void _onLoginConnectionErrorReceived(LoginConnectionErrorReceivedE event, Emitter<LoginState> emit) async {
    try {
      emit(LoginConnectionError(message: event.message));
    } catch (e) {
      print(e);
    }
  }

  void _onLoginDisconnectFromServer(LoginDisconnectFromServerE event, Emitter<LoginState> emit) async {
    try {
      _webSocketBloc.add(WSDisconnectFromServerE());
    } catch (e) {
      print(e);
    }
  }

  void _onLoginDisconnectedFromServer(LoginDisconnectedFromServerE event, Emitter<LoginState> emit) async {
    try {
      var username = SessionDataSingleton().getUsername();
      var serverAddress = SessionDataSingleton().getServerAddress();
      emit(LoginDisconnectedFromServer(message: event.message, username: username, serverAddress: serverAddress));
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
