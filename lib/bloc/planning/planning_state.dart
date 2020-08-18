import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PlanningState extends Equatable {
  const PlanningState();

  @override
  List<Object> get props => [];
}

class PlanningInitial extends PlanningState {
  @override
  String toString() => 'PlanningInitial';
}

class MessageLoading extends PlanningState {
  @override
  String toString() => 'MessageLoading';
}

class MessageLoaded extends PlanningState {
  final String message;

  const MessageLoaded({@required this.message}) : assert(message != null);

  @override
  String toString() => 'MessageLoaded: $message';
}

class ConnectedToServer extends PlanningState {
  final String message;

  const ConnectedToServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'ConnectedToServer $message';
}

class DisconnectedFromServer extends PlanningState {
  final String message;

  const DisconnectedFromServer({@required this.message}) : assert(message != null);

  @override
  String toString() => 'DisconnectedFromServer $message';
}
