// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import '../../data/models/rooms.dart';

// abstract class PlanningState extends Equatable {
//   const PlanningState();

//   @override
//   List<Object> get props => [];
// }

// class PlanningInitial extends PlanningState {
//   @override
//   String toString() => 'PlanningInitial';
// }

// class PlanningLoading extends PlanningState {
//   @override
//   String toString() => 'PlanningLoading';
// }

// class PlanningLoaded extends PlanningState {
//   final Planning rooms;

//   const PlanningLoaded({@required this.rooms}) : assert(rooms != null);

//   @override
//   String toString() => 'PlanningLoaded ${rooms.roomList}';
// }

// class PlanningError extends PlanningState {
//   final String message;

//   const PlanningError({@required this.message}) : assert(message != null);

//   @override
//   String toString() => 'PlanningError $message';
// }
