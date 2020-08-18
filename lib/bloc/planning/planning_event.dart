import 'package:equatable/equatable.dart';
import 'package:scrum_poker_app/bloc/planning/bloc.dart';

abstract class PlanningEvent extends Equatable {
  const PlanningEvent();

  @override
  List<Object> get props => [];
}

class ConnectToServer extends PlanningEvent {
  final String link;

  ConnectToServer(this.link);

  @override
  String toString() => 'ConnectToServer';
}

class SendMessage extends PlanningEvent {
  final String message;

  SendMessage(this.message);

  @override
  String toString() => 'SendMessage';
}

class MessageRecieved extends PlanningEvent {
  final String message;

  MessageRecieved(this.message);

  @override
  String toString() => 'Message recieved: $message';
}

class DisconnectFromServer extends PlanningEvent {
  final String message;

  DisconnectFromServer(this.message);

  @override
  String toString() => 'Disconnect from server: $message';
}