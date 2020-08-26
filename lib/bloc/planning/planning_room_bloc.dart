import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/data/repositories/repositories.dart';
import 'package:scrum_poker_app/data/repositories/rooms_repository.dart';
import '../websocket/bloc.dart';
import 'bloc.dart';

class PlanningRoomBloc extends Bloc<PlanningRoomEvent, PlanningRoomState> {
  final WebSocketBloc _webSocketBloc;
  StreamSubscription webSocketSubscription;
  final RoomsRepository _roomsRepository;

  PlanningRoomBloc(
      {@required WebSocketBloc webSocketBloc,
      @required RoomsRepository roomsRepository})
      : assert(webSocketBloc != null),
        _webSocketBloc = webSocketBloc,
        _roomsRepository = roomsRepository,
        super(PlanningRoomInitial()) {
    webSocketSubscription = _webSocketBloc.listen((state) {

    });
  }

  @override
  Stream<PlanningRoomState> mapEventToState(PlanningRoomEvent event) async* {
    if (event is PlanningRoomLoadedE) {
      yield* _mapPlanningRoomLoadedEToState(event);
    } else if (event is PlanningRoomCreateRoomE) {
      yield* _mapPlanningRoomCreateRoomEToState(event);
    } else if (event is PlanningRoomConnectToRoomE) {
      yield* _mapPlanningRoomConnectToRoomEToState(event);
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomLoadedEToState(event) async* {
    yield PlanningRoomLoading();
    try {
      yield PlanningRoomLoaded(rooms: event.rooms);
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not load list of rooms.");
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomCreateRoomEToState(event) async* {
    try {
      await _roomsRepository.createRoom(event.roomName);
    } on BadRequestException catch (e) {
      print(e);
      yield PlanningRoomError(message: e.message);
    } on NotFoundException catch (e) {
      print(e);
      yield PlanningRoomError(message: e.message);
    } on ResourceExistsException catch (e) {
      print(e);
      yield PlanningRoomError(message: e.message);
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not create room.");
    }
  }

  Stream<PlanningRoomState> _mapPlanningRoomConnectToRoomEToState(event) async* {
    try {
    } catch (e) {
      print(e);
      yield PlanningRoomError(message: "Could not connect to room.");
    }
  }

  @override
  Future<void> close() {
    webSocketSubscription.cancel();
    return super.close();
  }
}
