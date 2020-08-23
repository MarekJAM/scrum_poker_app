import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/rooms.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();

  @override
  List<Object> get props => [];
}

class RoomsInitial extends RoomsState {
  @override
  String toString() => 'RoomsInitial';
}

class RoomsLoading extends RoomsState {
  @override
  String toString() => 'RoomsLoading';
}

class RoomsLoaded extends RoomsState {
  final Rooms rooms;

  const RoomsLoaded({@required this.rooms}) : assert(rooms != null);

  @override
  String toString() => 'RoomsLoaded ${rooms.roomList}';
}

class RoomsError extends RoomsState {
  final String message;

  const RoomsError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'RoomsError $message';
}
