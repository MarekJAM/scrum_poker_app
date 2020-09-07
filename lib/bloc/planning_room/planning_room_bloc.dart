import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../utils/secure_storage.dart';
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
    } else if (event is PlanningRoomSendEstimateRequestE) {
      yield* _mapPlanningRoomSendEstimateRequestEToState(event);
    } else if (event is PlanningRoomSendEstimateE) {
      yield* _mapPlanningRoomSendEstimateEToState(event);
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomRoomiesReceivedEToState(event) async* {
    yield PlanningRoomRoomStatusLoading();
    try {
      var amAdmin = event.roomStatus.admins.contains(await SecureStorage().readUsername());
      yield PlanningRoomRoomStatusLoaded(roomStatus: event.roomStatus, amAdmin: amAdmin);
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not load list of room status.");
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomSendEstimateRequestEToState(event) async* {
    try {
      _webSocketBloc.add(WSSendMessageE(OutgoingMessage.createRequestEstimateJsonMsg(event.taskNumber)));
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not send estimate request.");
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomSendEstimateEToState(event) async* {
    try {
      _webSocketBloc.add(WSSendMessageE(OutgoingMessage.createEstimateJsonMsg(event.estimate)));
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not send estimate.");
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
