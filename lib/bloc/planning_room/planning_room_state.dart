import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../ui/ui_models/ui_models.dart';

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
  final EstimatedTaskInfo estimatedTaskInfo;
  final bool amAdmin;
  final bool alreadyEstimated;
  final List<UserEstimationCard> userEstimationCards;

  const PlanningRoomRoomStatusLoaded({@required this.estimatedTaskInfo, @required this.amAdmin, @required this.alreadyEstimated, @required this.userEstimationCards}) : assert(estimatedTaskInfo != null), assert(amAdmin != null), assert(alreadyEstimated != null);

  @override
  String toString() => 'PlanningRoomRoomStatusLoaded $estimatedTaskInfo';
}

class PlanningRoomError extends PlanningRoomState {
  final String message;

  const PlanningRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'PlanningRoomError $message';
}
