import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/rooms.dart';

abstract class PlanningRoomState extends Equatable {
  const PlanningRoomState();

  @override
  List<Object> get props => [];
}

class PlanningRoomInitial extends PlanningRoomState {
  @override
  String toString() => 'PlanningRoomInitial';
}

class PlanningRoomLoading extends PlanningRoomState {
  @override
  String toString() => 'PlanningRoomLoading';
}

class PlanningRoomLoaded extends PlanningRoomState {
  final String rooms;

  const PlanningRoomLoaded({@required this.rooms}) : assert(rooms != null);

  @override
  String toString() => 'PlanningRoomLoaded $rooms';
}

class PlanningRoomError extends PlanningRoomState {
  final String message;

  const PlanningRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'PlanningRoomError $message';
}
