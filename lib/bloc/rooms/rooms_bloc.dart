import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../data/repositories/rooms_repository.dart';
import '../../data/models/rooms.dart';
import '../websocket/bloc.dart';
import 'bloc.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;
  final RoomsRepository _roomsRepository;

  RoomsBloc(
      {@required WebSocketBloc webSocketBloc,
      @required RoomsRepository roomsRepository})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        _roomsRepository = roomsRepository,
        super(RoomsInitial()) {
    webSocketSubscription = _webSocketBloc.listen((state) {
      if (state is WSMessageLoaded && state.message is Rooms) {
        add(RoomsLoadedE(state.message));
      }
    });
  }

  @override
  Stream<RoomsState> mapEventToState(RoomsEvent event) async* {
    if (event is RoomsLoadedE) {
      yield* _mapRoomsLoadedEToState(event);
    } else if (event is RoomsCreateRoomE) {
      yield* _mapRoomsCreateRoomEToState(event);
    } else if (event is RoomsConnectToRoomE) {
      yield* _mapRoomsConnectToRoomEToState(event);
    } else if (event is RoomsDisconnectFromRoomE) {
      yield* _mapRoomsDisconnectFromRoomEToState();
    }
  }

  Stream<RoomsState> _mapRoomsLoadedEToState(event) async* {
    yield RoomsLoading();
    try {
      yield RoomsLoaded(rooms: event.rooms);
    } catch (e) {
      print(e);
      yield RoomsLoadingError(message: "Could not load list of rooms.");
    }
  }

  Stream<RoomsState> _mapRoomsCreateRoomEToState(event) async* {
    yield RoomsConnectingToRoom();
    try {
      await _roomsRepository.createRoom(event.roomName);
      yield RoomsConnectedToRoom(roomName: event.roomName);
    } catch (e) {
      print(e);
      yield RoomsConnectionWithRoomError(message: e.message);
    }
  }

  Stream<RoomsState> _mapRoomsConnectToRoomEToState(event) async* {
    yield RoomsConnectingToRoom();
    try {
      await _roomsRepository.connectToRoom(event.roomName);
      yield RoomsConnectedToRoom(roomName: event.roomName);
    } catch (e) {
      print(e);
      yield RoomsConnectionWithRoomError(message: e.message);
    }
  }

  Stream<RoomsState> _mapRoomsDisconnectFromRoomEToState() async* {
    try {
      await _roomsRepository.disconnectFromRoom();
      yield RoomsDisconnectedFromRoom();
    } catch (e) {
      print(e);
      yield RoomsConnectionWithRoomError(message: e.message);
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
