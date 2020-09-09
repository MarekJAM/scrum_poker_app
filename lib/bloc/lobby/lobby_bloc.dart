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
  final RoomsRepository _roomsRepository;

  LobbyBloc(
      {@required WebSocketBloc webSocketBloc,
      @required RoomsRepository roomsRepository})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        _roomsRepository = roomsRepository,
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
    } else if (event is LobbyCreateRoomE) {
      yield* _mapLobbyCreateRoomEToState(event);
    } else if (event is LobbyConnectToRoomE) {
      yield* _mapLobbyConnectToRoomEToState(event);
    } else if (event is LobbyDisconnectFromRoomE) {
      yield* _mapLobbyDisconnectFromRoomEToState();
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

  Stream<LobbyState> _mapLobbyCreateRoomEToState(event) async* {
    yield LobbyConnectingToRoom();
    try {
      await _roomsRepository.createRoom(event.roomName);
      yield LobbyConnectedToRoom(roomName: event.roomName);
    } catch (e) {
      print(e);
      yield LobbyConnectionWithRoomError(message: e.message);
    }
  }

  Stream<LobbyState> _mapLobbyConnectToRoomEToState(event) async* {
    yield LobbyConnectingToRoom();
    try {
      await _roomsRepository.connectToRoom(event.roomName);
      yield LobbyConnectedToRoom(roomName: event.roomName);
    } catch (e) {
      print(e);
      yield LobbyConnectionWithRoomError(message: e.message);
    }
  }

  Stream<LobbyState> _mapLobbyDisconnectFromRoomEToState() async* {
    try {
      await _roomsRepository.disconnectFromRoom();
      yield LobbyDisconnectedFromRoom();
    } catch (e) {
      print(e);
      yield LobbyConnectionWithRoomError(message: e.message);
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
