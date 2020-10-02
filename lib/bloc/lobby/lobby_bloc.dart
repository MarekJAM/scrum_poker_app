import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repositories/rooms_repository.dart';
import '../../data/models/lobby_status.dart';
import '../websocket/bloc.dart';
import 'bloc.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;

  LobbyBloc(
      {@required WebSocketBloc webSocketBloc,
      @required RoomsRepository roomsRepository})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        super(LobbyInitial()) {
    webSocketSubscription = _webSocketBloc.listen((state) {
      if (state is WSMessageLoaded && state.message is LobbyStatus) {
        add(LobbyStatusLoadedE(state.message));
      }
    });
  }

  @override
  Stream<LobbyState> mapEventToState(LobbyEvent event) async* {
    if (event is LobbyStatusLoadedE) {
      yield* _mapLobbyLoadedEToState(event);
    } 
  }

  Stream<LobbyState> _mapLobbyLoadedEToState(event) async* {
    yield LobbyLoading();
    try {
      yield LobbyStatusLoaded(lobbyStatus: event.lobbyStatus);
    } catch (e) {
      print(e);
      yield LobbyLoadingError(message: "Could not load lobby status.");
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
