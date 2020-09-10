import 'package:equatable/equatable.dart';
import '../../data/models/lobby_status.dart';

abstract class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object> get props => [];
}

class LobbyStatusLoadedE extends LobbyEvent {
  final LobbyStatus lobbyStatus;

  LobbyStatusLoadedE(this.lobbyStatus);

  @override
  String toString() => 'LobbyStatusLoadedE $lobbyStatus';
}

class LobbyErrorReceivedE extends LobbyEvent {
  final String message;

  LobbyErrorReceivedE(this.message);

  @override
  String toString() => 'LobbyErrorReceivedE: $message';
}
