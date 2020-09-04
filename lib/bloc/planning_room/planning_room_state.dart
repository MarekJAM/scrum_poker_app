import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/roomies.dart';

abstract class PlanningRoomState extends Equatable {
  const PlanningRoomState();

  @override
  List<Object> get props => [];
}

class PlanningRoomInitial extends PlanningRoomState {
  @override
  String toString() => 'PlanningRoomInitial';
}

class PlanningRoomRoomiesLoading extends PlanningRoomState {
  @override
  String toString() => 'PlanningRoomRoomiesLoading';
}

class PlanningRoomRoomiesLoaded extends PlanningRoomState {
  final Roomies roomies;

  const PlanningRoomRoomiesLoaded({@required this.roomies}) : assert(roomies != null);

  @override
  String toString() => 'PlanningRoomRoomiesLoaded $roomies';
}

class PlanningRoomError extends PlanningRoomState {
  final String message;

  const PlanningRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'PlanningRoomError $message';
}
