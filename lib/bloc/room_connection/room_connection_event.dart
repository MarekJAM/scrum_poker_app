part of 'room_connection_bloc.dart';

abstract class RoomConnectionEvent extends Equatable {
  const RoomConnectionEvent();

  @override
  List<Object> get props => [];
}

class RoomConnectionCreateRoomE extends RoomConnectionEvent {
  final String roomName;

  RoomConnectionCreateRoomE(this.roomName);

  @override
  String toString() => 'RoomConnectionCreateRoomE';
}

class RoomConnectionConnectToRoomE extends RoomConnectionEvent {
  final String roomName;
  final bool asSpectator;

  RoomConnectionConnectToRoomE(this.roomName, this.asSpectator);

  @override
  String toString() => 'RoomConnectionConnectToRoomE';
}

class RoomConnectionDisconnectFromRoomE extends RoomConnectionEvent {
  @override
  String toString() => 'RoomConnectionDisconnectFromRoomE';
}

class RoomConnectionDestroyRoomE extends RoomConnectionEvent {
  @override
  String toString() => 'RoomConnectionDestroyRoomE';
}
