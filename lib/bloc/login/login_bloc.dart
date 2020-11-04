import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import '../websocket/bloc.dart';
import '../../utils/secure_storage.dart';
import '../../data/repositories/repositories.dart';
import '../../utils/globals.dart' as globals;

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
      var username = await SecureStorage().readUsername();
      var serverAddress = await SecureStorage().readServerAddress();
      yield LoginDisconnectedFromServer(
          username: username, serverAddress: serverAddress);
    } catch (e) {
      print(e);
      yield LoginConnectionError(message: "Connection error occured.");
    }
  }

  Stream<LoginState> _mapLoginConnectToServerToState(LoginConnectToServerE event) async* {
    yield LoginConnectingToServer();
    try {
      //this is temporary solution only
      globals.serverURL = event.serverUrl;

      await SecureStorage().writeServerAddress(event.serverUrl);
      await SecureStorage().writeUsername(event.username);

      await _authRepository.login(event.username, event.password);

      _webSocketBloc.add(
          WSConnectToServerE("ws://" + event.serverUrl));
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
      var username = await SecureStorage().readUsername();
      var serverAddress = await SecureStorage().readServerAddress();
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
