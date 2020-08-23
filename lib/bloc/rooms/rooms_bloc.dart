import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/rooms.dart';
import '../websocket/bloc.dart';
import 'bloc.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;

  RoomsBloc({@required WebSocketBloc webSocketBloc})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        super(RoomsInitial()) {
    webSocketSubscription = _webSocketBloc.listen((state) {
      if (state is WSMessageLoaded) {
        add(RoomsLoadedE(state.message));
      }
    });
  }

  @override
  Stream<RoomsState> mapEventToState(RoomsEvent event) async* {
    if (event is RoomsLoadedE) {
      yield* _mapRoomsLoadedEToState(event);
    }
  }

  Stream<RoomsState> _mapRoomsLoadedEToState(event) async* {
    yield RoomsLoading();
    try {
      yield RoomsLoaded(rooms: event.rooms);
    } catch (e) {
      print(e);
      yield RoomsError(message: "Could not load list of rooms.");
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
