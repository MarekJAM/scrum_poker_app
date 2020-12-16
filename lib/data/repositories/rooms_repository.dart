import 'package:flutter/material.dart';
import 'repositories.dart';

class RoomsRepository {
  final RoomsApiClient roomsApiClient;

  RoomsRepository({@required this.roomsApiClient})
      : assert(RoomsApiClient != null);

  Future<bool> createRoom(String roomName) async {
    return await roomsApiClient.createRoom(roomName);
  }

  Future<bool> connectToRoom(String roomName, bool asSpectator) async {
    return await roomsApiClient.connectToRoom(roomName, asSpectator);
  }

  Future<bool> disconnectFromRoom() async {
    return await roomsApiClient.disconnectFromRoom();
  }

  Future<bool> destroyRoom() async {
    return await roomsApiClient.destroyRoom();
  }
}
