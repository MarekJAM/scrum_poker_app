import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/room_status.dart';
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
      if (state is WSMessageLoaded && state.message is RoomStatus) {
        add(PlanningRoomRoomStatusReceivedE(state.message));
      }
    });
  }

  @override
  Stream<PlanningRoomState> mapEventToState(PlanningRoomEvent event) async* {
    if (event is PlanningRoomRoomStatusReceivedE) {
      yield* _mapPlanningRoomRoomiesReceivedEToState(event);
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomRoomiesReceivedEToState(event) async* {
    yield PlanningRoomRoomStatusLoading();
    try {
      yield PlanningRoomRoomStatusLoaded(roomStatus: event.roomStatus);
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not load list of room status.");
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
