import 'package:equatable/equatable.dart';
import '../../data/models/roomies.dart';

abstract class PlanningRoomEvent extends Equatable {
  const PlanningRoomEvent();

  @override
  List<Object> get props => [];
}

class PlanningRoomRoomiesReceivedE extends PlanningRoomEvent {
  final Roomies roomies;

  PlanningRoomRoomiesReceivedE(this.roomies);

  @override
  String toString() => 'PlanningRoomRoomiesReceivedE $roomies';
}

class PlanningRoomSendEstimateRequestE extends PlanningRoomEvent {
  final String task;

  PlanningRoomSendEstimateRequestE(this.task);

  @override
  String toString() => 'PlanningRoomSendEstimateRequestE';
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
