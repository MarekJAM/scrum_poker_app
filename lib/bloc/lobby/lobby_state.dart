import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/lobby_status.dart';

abstract class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object> get props => [];
}

class LobbyInitial extends LobbyState {
  @override
  String toString() => 'LobbyInitial';
}

class LobbyLoading extends LobbyState {
  @override
  String toString() => 'LobbyLoading';
}

class LobbyStatusLoaded extends LobbyState {
  final LobbyStatus lobbyStatus;

  const LobbyStatusLoaded({@required this.lobbyStatus}) : assert(lobbyStatus != null);

  @override
  String toString() => 'LobbyStatusLoaded ${lobbyStatus.rooms} ${lobbyStatus.leftRoomReason}';
}

class LobbyLoadingError extends LobbyState {
  final String message;

  const LobbyLoadingError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'LobbyLoadingError $message';
}

class LobbyConnectingToRoom extends LobbyState {
  @override
  String toString() => 'LobbyConnectingToRoom';
}

class LobbyConnectedToRoom extends LobbyState {
  final String roomName;

  const LobbyConnectedToRoom({@required this.roomName}) : assert(roomName != null);

  @override
  String toString() => 'LobbyConnectedToRoom $roomName';
}

class LobbyConnectionWithRoomError extends LobbyState {
  final String message;

  const LobbyConnectionWithRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'LobbyConnectionWithRoomError $message';
}

class LobbyDisconnectedFromRoom extends LobbyState {
  @override
  String toString() => 'LobbyDisconnectedFromRoom';
}
