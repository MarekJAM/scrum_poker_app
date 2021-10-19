import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../data/models/lobby_status.dart';
import '../websocket/websocket_bloc.dart';
import '../../ui/ui_models/ui_models.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;
  final LobbyRepository _lobbyRepository;

  LobbyBloc({
    @required WebSocketBloc webSocketBloc,
    @required LobbyRepository lobbyRepository,
  })  : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        _lobbyRepository = lobbyRepository,
        super(LobbyInitial()) {
    webSocketSubscription = _webSocketBloc.stream.listen((state) {
      if (state is WSMessageLoaded && state.message is LobbyStatus) {
        add(LobbyStatusLoadedE(state.message));
      }
    });
    on<LobbyStatusLoadedE>(_onLobbyLoadedE);
  }


  void _onLobbyLoadedE(LobbyStatusLoadedE event, Emitter<LobbyState> emit) async {
    emit(LobbyLoading());
    try {
      final lobbyStatus =
          await _lobbyRepository.processLobbyStatusToUIModel(event.lobbyStatus);
      emit(LobbyStatusLoaded(lobbyStatus: lobbyStatus));
    } catch (e) {
      print(e);
      emit(LobbyLoadingError(message: "Could not load lobby status."));
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
