import 'package:equatable/equatable.dart';

abstract class PlanningRoomEvent extends Equatable {
  const PlanningRoomEvent();

  @override
  List<Object> get props => [];
}

class PlanningRoomLoadedE extends PlanningRoomEvent {
  final String rooms;

  PlanningRoomLoadedE(this.rooms);

  @override
  String toString() => 'PlanningRoomLoadedE $rooms';
}

class PlanningRoomCreateRoomE extends PlanningRoomEvent {
  final String roomName;

  PlanningRoomCreateRoomE(this.roomName);

  @override
  String toString() => 'PlanningRoomCreateRoomE';
}

class PlanningRoomConnectToRoomE extends PlanningRoomEvent {
  final String roomName;

  PlanningRoomConnectToRoomE(this.roomName);

  @override
  String toString() => 'PlanningRoomConnectToRoomE';
}

class PlanningRoomErrorReceivedE extends PlanningRoomEvent {
  final String message;

  PlanningRoomErrorReceivedE(this.message);

  @override
  String toString() => 'PlanningRoomErrorReceivedE: $message';
}
