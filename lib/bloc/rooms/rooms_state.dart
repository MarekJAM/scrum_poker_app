import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/rooms.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsInitial extends RoomsState {
  @override
  String toString() => 'RoomsInitial';
}

class RoomsLoading extends RoomsState {
  @override
  String toString() => 'RoomsLoading';
}

class RoomsLoaded extends RoomsState {
  final Rooms rooms;

  const RoomsLoaded({@required this.rooms}) : assert(rooms != null);

  @override
  String toString() => 'RoomsLoaded ${rooms.roomList}';
}

class RoomsLoadingError extends RoomsState {
  final String message;

  const RoomsLoadingError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'RoomsLoadingError $message';
}

class RoomsConnectingToRoom extends RoomsState {
  @override
  String toString() => 'RoomsConnectingToRoom';
}

class RoomsConnectedToRoom extends RoomsState {
  final String roomName;

  const RoomsConnectedToRoom({@required this.roomName}) : assert(roomName != null);

  @override
  String toString() => 'RoomsConnectedToRoom $roomName';
}

class RoomsConnectionWithRoomError extends RoomsState {
  final String message;

  const RoomsConnectionWithRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'RoomsConnectionWithRoomError $message';
}

class RoomsDisconnectedFromRoom extends RoomsState {
  @override
  String toString() => 'RoomsDisconnectedFromRoom';
}
