import 'package:equatable/equatable.dart';
import '../../data/models/rooms.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();

  @override
  List<Object> get props => [];
}

class RoomsLoadedE extends RoomsEvent {
  final Rooms rooms;

  RoomsLoadedE(this.rooms);

  @override
  String toString() => 'RoomsLoadedE $rooms';
}

class RoomsCreateRoomE extends RoomsEvent {
  final String roomName;

  RoomsCreateRoomE(this.roomName);

  @override
  String toString() => 'RoomsCreateRoomE';
}

class RoomsConnectToRoomE extends RoomsEvent {
  final String roomName;

  RoomsConnectToRoomE(this.roomName);

  @override
  String toString() => 'RoomsConnectToRoomE';
}

class RoomsErrorReceivedE extends RoomsEvent {
  final String message;

  RoomsErrorReceivedE(this.message);

  @override
  String toString() => 'RoomsErrorReceivedE: $message';
}
