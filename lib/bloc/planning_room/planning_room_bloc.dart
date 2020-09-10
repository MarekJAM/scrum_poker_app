import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../utils/secure_storage.dart';
import '../websocket/bloc.dart';
import '../../ui/ui_models/ui_models.dart';
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

  Stream<PlanningRoomState> _mapPlanningRoomRoomiesReceivedEToState(
      event) async* {
    yield PlanningRoomRoomStatusLoading();
    try {
      final myUsername = await SecureStorage().readUsername();
      final amAdmin = event.roomStatus.admins.contains(myUsername);
      bool alreadyEstimated;
      alreadyEstimated = ((event.roomStatus.estimates.singleWhere(
              (estimate) => estimate.name == myUsername,
              orElse: () => null)) !=
          null);

      List<UserEstimationCard> userEstimationCardsUI = [];

      event.roomStatus.admins.forEach((admin) {
        userEstimationCardsUI
            .add(UserEstimationCard(username: admin, isAdmin: true, isInRoom: true));
      });
      event.roomStatus.estimators.forEach((estimator) {
        userEstimationCardsUI
            .add(UserEstimationCard(username: estimator, isAdmin: false, isInRoom: true));
      });

      //checks if all users who estimated are still in the room, and if not adds them at the end of the list
      event.roomStatus.estimates.forEach((estimate) {
        var index = userEstimationCardsUI
            .indexWhere((card) => card.username == estimate.name);
        if (index >= 0) {
          userEstimationCardsUI[index]
            ..isInRoom = true
            ..estimate = estimate.estimate;
        } else {
          userEstimationCardsUI.add(UserEstimationCard(
            username: estimate.name,
            estimate: estimate.estimate,
          ));
        }
      });

      yield PlanningRoomRoomStatusLoaded(
        roomStatus: event.roomStatus,
        amAdmin: amAdmin,
        alreadyEstimated: alreadyEstimated,
        userEstimationCards: userEstimationCardsUI,
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
