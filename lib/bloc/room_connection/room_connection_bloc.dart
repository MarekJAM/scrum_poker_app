import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/repositories.dart';
import '../../data/repositories/rooms_repository.dart';

part 'room_connection_event.dart';
part 'room_connection_state.dart';

class RoomConnectionBloc
    extends Bloc<RoomConnectionEvent, RoomConnectionState> {
  final RoomsRepository _roomsRepository;

  RoomConnectionBloc({@required RoomsRepository roomsRepository})
      : assert(roomsRepository != null),
        _roomsRepository = roomsRepository,
        super(RoomConnectionInitial());

  @override
  Stream<RoomConnectionState> mapEventToState(
      RoomConnectionEvent event) async* {
    if (event is RoomConnectionCreateRoomE) {
      yield* _mapRoomConnectionCreateRoomEToState(event);
    } else if (event is RoomConnectionConnectToRoomE) {
      yield* _mapRoomConnectionConnectToRoomEToState(event);
    } else if (event is RoomConnectionDisconnectFromRoomE) {
      yield* _mapRoomConnectionDisconnectFromRoomEToState();
    } else if (event is RoomConnectionDestroyRoomE) {
      yield* _mapRoomConnectionDestroyRoomEToState();
    }
  }

  Stream<RoomConnectionState> _mapRoomConnectionConnectToRoomEToState(
      event) async* {
    yield RoomConnectionConnecting();
    try {
      await _roomsRepository.connectToRoom(event.roomName);
      yield RoomConnectionConnectedToRoom(roomName: event.roomName);
    } catch (e) {
      print(e);
      yield RoomConnectionError(message: e.message);
    }
  }

  Stream<RoomConnectionState> _mapRoomConnectionCreateRoomEToState(
      event) async* {
    yield RoomConnectionConnecting();
    try {
      await _roomsRepository.createRoom(event.roomName);
      yield RoomConnectionConnectedToRoom(roomName: event.roomName);
    } catch (e) {
      print(e);
      yield RoomConnectionError(message: e.message);
    }
  }

  Stream<RoomConnectionState>
      _mapRoomConnectionDisconnectFromRoomEToState() async* {
    yield RoomConnectionDisconnectingFromRoom();
    try {
      await _roomsRepository.disconnectFromRoom();
      yield RoomConnectionDisconnectedFromRoom();
    } catch (e) {
      print(e);
      yield RoomConnectionDisconnectingFromRoomError(
          message: "Failed to disconnect from room.");
    }
  }

  Stream<RoomConnectionState>
      _mapRoomConnectionDestroyRoomEToState() async* {
    yield RoomConnectionDestroyingRoom();
    try {
      await _roomsRepository.destroyRoom();
      yield RoomConnectionDestroyedRoom();
    } catch (e) {
      print(e);
      yield RoomConnectionDestroyingRoomError(
          message: "Failed to destroy the room.");
    }
  }
}
