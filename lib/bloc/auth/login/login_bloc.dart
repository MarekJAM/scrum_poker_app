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
    webSocketSubscription = _webSocketBloc.listen((state) {
      if (state is WSConnectedToServer) {
        add(LoginConnectedToServerE());
      } else if (state is WSDisconnectedFromServer) {
        add(LoginDisconnectedFromServerE(state.message));
      } else if (state is WSConnectionError) {
        add(LoginConnectionErrorReceivedE(state.message));
      }
    });
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginConnectToServerE) {
      yield* _mapLoginConnectToServerToState(event);
    } else if (event is LoginConnectedToServerE) {
      yield* _mapLoginConnectedToServerEToState();
    } else if (event is LoginConnectionErrorReceivedE) {
      yield* _mapLoginConnectionErrorReceivedToState(event);
    } else if (event is LoginDisconnectFromServerE) {
      yield* _mapLoginDisconnectFromServerToState(event);
    } else if (event is LoginDisconnectedFromServerE) {
      yield* _mapLoginDisconnectedFromServerToState(event);
    } else if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
  }

  // temporary solution, normally some kind of autologin attempt should be here
  Stream<LoginState> _mapAppStartedToState() async* {
    try {
      await SessionDataSingleton().init();
      yield LoginDisconnectedFromServer(
          username: SessionDataSingleton().getUsername(),
          serverAddress: SessionDataSingleton().getServerAddress());
    } catch (e) {
      print(e);
      yield LoginConnectionError(message: "Connection error occured.");
    }
  }

  Stream<LoginState> _mapLoginConnectToServerToState(
      LoginConnectToServerE event) async* {
    yield LoginConnectingToServer();
    try {
      //this is temporary solution only
      await SessionDataSingleton().setServerAddress(event.serverAddress);
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
      yield LoginConnectionError(
          message: "Could not establish connection with server.");
    } catch (e) {
      print(e);
      yield LoginConnectionError(message: e.message);
    }
  }

  Stream<LoginState> _mapLoginConnectedToServerEToState() async* {
    try {
      yield LoginConnectedToServer(message: "Connected to server");
    } catch (e) {
      print(e);
    }
  }

  Stream<LoginState> _mapLoginConnectionErrorReceivedToState(event) async* {
    try {
      yield LoginConnectionError(message: event.message);
    } catch (e) {
      print(e);
    }
  }

  Stream<LoginState> _mapLoginDisconnectFromServerToState(event) async* {
    try {
      _webSocketBloc.add(WSDisconnectFromServerE());
    } catch (e) {
      print(e);
    }
  }

  Stream<LoginState> _mapLoginDisconnectedFromServerToState(event) async* {
    try {
      var username = SessionDataSingleton().getUsername();
      var serverAddress = SessionDataSingleton().getServerAddress();
      yield LoginDisconnectedFromServer(
          message: event.message,
          username: username,
          serverAddress: serverAddress);
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
