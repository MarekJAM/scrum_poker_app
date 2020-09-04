import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/roomies.dart';
import '../websocket/bloc.dart';
import 'bloc.dart';

class PlanningRoomBloc extends Bloc<PlanningRoomEvent, PlanningRoomState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;

  PlanningRoomBloc({@required WebSocketBloc webSocketBloc})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        super(PlanningRoomInitial()) {
    webSocketSubscription = _webSocketBloc.listen((state) {
      if (state is WSMessageLoaded && state.message is Roomies) {
        add(PlanningRoomRoomiesReceivedE(state.message));
      }
    });
  }

  @override
  Stream<PlanningRoomState> mapEventToState(PlanningRoomEvent event) async* {
    if (event is PlanningRoomRoomiesReceivedE) {
      yield* _mapPlanningRoomRoomiesReceivedEToState(event);
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomRoomiesReceivedEToState(
      event) async* {
    try {
      yield PlanningRoomRoomiesLoaded(roomies: event.roomies);
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not load list of roomies.");
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
