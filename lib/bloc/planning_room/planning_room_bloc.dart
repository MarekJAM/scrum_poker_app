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
    webSocketSubscription = _webSocketBloc.stream.listen((state) {
      if (state is WSMessageLoaded && state.message is RoomStatus) {
        add(PlanningRoomRoomStatusReceivedE(state.message));
      }
    });
    on<PlanningRoomRoomStatusReceivedE>(_onPlanningRoomRoomStatusReceivedE);
    on<PlanningRoomSendEstimateRequestE>(_onPlanningRoomSendEstimateRequestE);
    on<PlanningRoomSendEstimateE>(_onPlanningRoomSendEstimateE);
  }

  void _onPlanningRoomRoomStatusReceivedE(
      PlanningRoomRoomStatusReceivedE event, Emitter<PlanningRoomState> emit) async {
    emit(PlanningRoomRoomStatusLoading());
    
    try {
      final planningRoomStatusInfo = await _planningRoomRepository.processRoomStatusToUIModel(event.roomStatus);

      emit(PlanningRoomRoomStatusLoaded(planningRoomStatusInfo: planningRoomStatusInfo));
    } catch (e) {
      print(e);
      emit(PlanningRoomError(message: "Could not load room status."));
    }
  }

  void _onPlanningRoomSendEstimateRequestE(
      PlanningRoomSendEstimateRequestE event, Emitter<PlanningRoomState> emit) async {
    try {
      _webSocketBloc.add(WSSendMessageE(OutgoingMessage.createRequestEstimateJsonMsg(event.taskNumber)));
    } catch (e) {
      print(e);
      emit(PlanningRoomError(message: "Could not send estimate request."));
    }
  }

  void _onPlanningRoomSendEstimateE(PlanningRoomSendEstimateE event, Emitter<PlanningRoomState> emit) async {
    try {
      _webSocketBloc.add(WSSendMessageE(OutgoingMessage.createEstimateJsonMsg(event.estimate)));
    } catch (e) {
      print(e);
      emit(PlanningRoomError(message: "Could not send estimate."));
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
