part of 'lobby_bloc.dart';

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
