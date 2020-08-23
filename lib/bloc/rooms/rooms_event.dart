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

class RoomsSendMessageE extends RoomsEvent {
  final String message;

  RoomsSendMessageE(this.message);

  @override
  String toString() => 'RoomsSendMessageE';
}

class RoomsErrorReceivedE extends RoomsEvent {
  final String message;

  RoomsErrorReceivedE(this.message);

  @override
  String toString() => 'RoomsErrorReceivedE: $message';
}
