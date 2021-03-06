part of 'room_connection_bloc.dart';

abstract class RoomConnectionState extends Equatable {
  const RoomConnectionState();

  @override
  List<Object> get props => [];
}

class RoomConnectionInitial extends RoomConnectionState {
  @override
  String toString() => 'RoomConnectionInitial';
}

class RoomConnectionConnecting extends RoomConnectionState {
  @override
  String toString() => 'RoomConnectionConnecting';
}

class RoomConnectionConnectedToRoom extends RoomConnectionState {
  final String roomName;

  const RoomConnectionConnectedToRoom({@required this.roomName}) : assert(roomName != null);

  @override
  String toString() => 'RoomConnectionConnectedToRoom - room name: $roomName';
}

class RoomConnectionError extends RoomConnectionState {
  final String message;

  const RoomConnectionError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'RoomConnectionError $message';
}

class RoomConnectionDisconnectingFromRoom extends RoomConnectionState {
  @override
  String toString() => 'RoomConnectionDisconnectingFromRoom';
}

class RoomConnectionDisconnectingFromRoomError extends RoomConnectionState {
  final String message;

  const RoomConnectionDisconnectingFromRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'RoomConnectionDisconnectingFromRoomError $message';
}

class RoomConnectionDisconnectedFromRoom extends RoomConnectionState {
  @override
  String toString() => 'RoomConnectionDisconnectedFromRoom';
}

class RoomConnectionDestroyingRoom extends RoomConnectionState {
  @override
  String toString() => 'RoomConnectionDestroyingRoom';
}

class RoomConnectionDestroyedRoom extends RoomConnectionState {
  @override
  String toString() => 'RoomConnectionDestroyedRoom';
}

class RoomConnectionDestroyingRoomError extends RoomConnectionState {
  final String message;

  const RoomConnectionDestroyingRoomError({@required this.message}) : assert(message != null);
  
  @override
  String toString() => 'RoomConnectionDestroyingRoomError';
}

