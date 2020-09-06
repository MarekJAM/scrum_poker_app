import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/room_status.dart';

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
  final RoomStatus roomStatus;
  final bool amAdmin;

  const PlanningRoomRoomStatusLoaded({@required this.roomStatus, @required this.amAdmin}) : assert(roomStatus != null), assert(amAdmin != null);

  @override
  String toString() => 'PlanningRoomRoomStatusLoaded $roomStatus';
}

class PlanningRoomError extends PlanningRoomState {
  final String message;

  const PlanningRoomError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'PlanningRoomError $message';
}
