import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../websocket/bloc.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;

  LoginBloc({@required WebSocketBloc webSocketBloc})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
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
      yield* _mapLoginDisconnectedFromServerToState();
    }
  }

  Stream<LoginState> _mapLoginConnectToServerToState(event) async* {
    yield LoginConnectingToServer();
    try {
      _webSocketBloc.add(WSConnectToServerE(event.link));
    } catch (e) {
      print(e);
      yield LoginConnectionError(message: "Connection error occured.");
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

  Stream<LoginState> _mapLoginDisconnectedFromServerToState() async* {
    try {
      yield LoginDisconnectedFromServer(message: "Disconnected from server");
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
