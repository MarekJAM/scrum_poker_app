part of 'planning_room_bloc.dart';

abstract class PlanningRoomState extends Equatable {
  const PlanningRoomState();

  @override
  List<Object> get props => [];
}

class PlanningRoomInitial extends PlanningRoomState {
  @override
  String toString() => 'PlanningRoomInitial';
}

class PlanningRoomRoomStatusLoading extends PlanningRoomState {
  @override
  String toString() => 'PlanningRoomRoomStatusLoading';
}

class PlanningRoomRoomStatusLoaded extends PlanningRoomState {
  final PlanningRoomStatusInfoUI planningRoomStatusInfo;

  const PlanningRoomRoomStatusLoaded({@required this.planningRoomStatusInfo})
      : assert(planningRoomStatusInfo != null);

  @override
  String toString() => 'PlanningRoomRoomStatusLoaded $planningRoomStatusInfo';
}

class PlanningRoomError extends PlanningRoomState {
  final String message;

  const PlanningRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'PlanningRoomError $message';
}
