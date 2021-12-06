import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/repositories.dart';
import '../../data/repositories/rooms_repository.dart';

part 'room_connection_event.dart';
part 'room_connection_state.dart';

class RoomConnectionBloc extends Bloc<RoomConnectionEvent, RoomConnectionState> {
  final RoomsRepository _roomsRepository;

  RoomConnectionBloc({@required RoomsRepository roomsRepository})
      : assert(roomsRepository != null),
        _roomsRepository = roomsRepository,
        super(RoomConnectionInitial()) {
    on<RoomConnectionConnectToRoomE>(_onRoomConnectionConnectToRoomE);
    on<RoomConnectionCreateRoomE>(_onRoomConnectionCreateRoomE);
    on<RoomConnectionDisconnectFromRoomE>(_onRoomConnectionDisconnectFromRoomE);
    on<RoomConnectionDestroyRoomE>(_onRoomConnectionDestroyRoomE);
  }

  void _onRoomConnectionConnectToRoomE(RoomConnectionConnectToRoomE event, Emitter<RoomConnectionState> emit) async {
    emit(RoomConnectionConnecting());
    try {
      await _roomsRepository.connectToRoom(event.roomName, event.asSpectator);
      emit(RoomConnectionConnectedToRoom(roomName: event.roomName));
    } catch (e) {
      print(e);
      emit(RoomConnectionError(message: e.message));
    }
  }

  void _onRoomConnectionCreateRoomE(RoomConnectionCreateRoomE event, Emitter<RoomConnectionState> emit) async {
    emit(RoomConnectionConnecting());
    try {
      await _roomsRepository.createRoom(event.roomName);
      emit(RoomConnectionConnectedToRoom(roomName: event.roomName));
    } catch (e) {
      print(e);
      emit(RoomConnectionError(message: e.message));
    }
  }

  void _onRoomConnectionDisconnectFromRoomE(
      RoomConnectionDisconnectFromRoomE event, Emitter<RoomConnectionState> emit) async {
    emit(RoomConnectionDisconnectingFromRoom());
    try {
      await _roomsRepository.disconnectFromRoom();
      emit(RoomConnectionDisconnectedFromRoom());
    } catch (e) {
      print(e);
      emit(RoomConnectionDisconnectingFromRoomError(message: "Failed to disconnect from room."));
    }
  }

  void _onRoomConnectionDestroyRoomE(RoomConnectionDestroyRoomE event, Emitter<RoomConnectionState> emit) async {
    emit(RoomConnectionDestroyingRoom());
    try {
      await _roomsRepository.destroyRoom();
      emit(RoomConnectionDestroyedRoom());
    } catch (e) {
      print(e);
      emit(RoomConnectionDestroyingRoomError(message: "Failed to destroy the room."));
    }
  }
}
