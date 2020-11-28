import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/repositories.dart';
import '../../ui/ui_models/ui_models.dart';
import '../../data/models/models.dart';
import '../websocket/websocket_bloc.dart';

part 'planning_room_event.dart';
part 'planning_room_state.dart';

class PlanningRoomBloc extends Bloc<PlanningRoomEvent, PlanningRoomState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;
  final PlanningRoomRepository _planningRoomRepository;

  PlanningRoomBloc({
    @required WebSocketBloc webSocketBloc,
    @required PlanningRoomRepository planningRoomRepository,
  })  : assert(webSocketBloc != null),
        assert(planningRoomRepository != null),
        _webSocketBloc = webSocketBloc,
        _planningRoomRepository = planningRoomRepository,
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
      yield* _mapPlanningRoomRoomStatusReceivedEToState(event);
    } else if (event is PlanningRoomSendEstimateRequestE) {
      yield* _mapPlanningRoomSendEstimateRequestEToState(event);
    } else if (event is PlanningRoomSendEstimateE) {
      yield* _mapPlanningRoomSendEstimateEToState(event);
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomRoomStatusReceivedEToState(
      event) async* {
    yield PlanningRoomRoomStatusLoading();
    try {
      final planningRoomStatusInfo = await _planningRoomRepository.processRoomStatusToUIModel(event.roomStatus);
      
      yield PlanningRoomRoomStatusLoaded(
        planningRoomStatusInfo: planningRoomStatusInfo
      );
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not load room status.");
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomSendEstimateRequestEToState(
      event) async* {
    try {
      _webSocketBloc.add(WSSendMessageE(
          OutgoingMessage.createRequestEstimateJsonMsg(event.taskNumber)));
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not send estimate request.");
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomSendEstimateEToState(event) async* {
    try {
      _webSocketBloc.add(WSSendMessageE(
          OutgoingMessage.createEstimateJsonMsg(event.estimate)));
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
