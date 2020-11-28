part of 'planning_room_bloc.dart';

abstract class PlanningRoomEvent extends Equatable {
  const PlanningRoomEvent();

  @override
  List<Object> get props => [];
}

class PlanningRoomRoomStatusReceivedE extends PlanningRoomEvent {
  final RoomStatus roomStatus;

  PlanningRoomRoomStatusReceivedE(this.roomStatus);

  @override
  String toString() => 'PlanningRoomRoomStatusReceivedE $roomStatus';
}

class PlanningRoomSendEstimateRequestE extends PlanningRoomEvent {
  final String taskNumber;

  PlanningRoomSendEstimateRequestE(this.taskNumber);

  @override
  String toString() => 'PlanningRoomSendEstimateRequestE: $taskNumber';
}

class PlanningRoomSendEstimateE extends PlanningRoomEvent {
  final int estimate;

  PlanningRoomSendEstimateE(this.estimate);

  @override
  String toString() => 'PlanningRoomSendEstimateE: $estimate';
}

class PlanningRoomErrorReceivedE extends PlanningRoomEvent {
  final String message;

  PlanningRoomErrorReceivedE(this.message);

  @override
  String toString() => 'PlanningRoomErrorReceivedE: $message';
}
