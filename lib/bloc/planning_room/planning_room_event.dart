import 'package:equatable/equatable.dart';
import '../../data/models/room_status.dart';

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

class PlanningRoomEstimateRequestReceivedE extends PlanningRoomEvent {
  final String task;

  PlanningRoomEstimateRequestReceivedE(this.task);

  @override
  String toString() => 'PlanningRoomEstimateRequestReceivedE';
}

class PlanningRoomSendEstimateE extends PlanningRoomEvent {
  final String estimate;

  PlanningRoomSendEstimateE(this.estimate);

  @override
  String toString() => 'PlanningRoomSendEstimateE';
}

class PlanningRoomEstimatesReceivedE extends PlanningRoomEvent {
  final String estimates;

  PlanningRoomEstimatesReceivedE(this.estimates);

  @override
  String toString() => 'PlanningRoomEstimatesReceivedE';
}

class PlanningRoomErrorReceivedE extends PlanningRoomEvent {
  final String message;

  PlanningRoomErrorReceivedE(this.message);

  @override
  String toString() => 'PlanningRoomErrorReceivedE: $message';
}
