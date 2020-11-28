part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object> get props => [];
}

class LobbyInitial extends LobbyState {
  @override
  String toString() => 'LobbyInitial';
}

class LobbyLoading extends LobbyState {
  @override
  String toString() => 'LobbyLoading';
}

class LobbyStatusLoaded extends LobbyState {
  final LobbyStatus lobbyStatus;

  const LobbyStatusLoaded({@required this.lobbyStatus}) : assert(lobbyStatus != null);

  @override
  String toString() => 'LobbyStatusLoaded ${lobbyStatus.rooms} ${lobbyStatus.leftRoomReason}';
}

class LobbyLoadingError extends LobbyState {
  final String message;

  const LobbyLoadingError({@required this.message}) : assert(message != null);

  @override
  String toString() => 'LobbyLoadingError $message';
}
