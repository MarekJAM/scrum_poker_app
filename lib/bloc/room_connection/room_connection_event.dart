import 'package:equatable/equatable.dart';

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

  RoomConnectionConnectToRoomE(this.roomName);

  @override
  String toString() => 'RoomConnectionConnectToRoomE';
}

class RoomConnectionDisconnectFromRoomE extends RoomConnectionEvent {
  @override
  String toString() => 'RoomConnectionDisconnectFromRoomE';
}
