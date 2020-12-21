import 'package:flutter/material.dart';

import '../../ui/ui_models/ui_models.dart';
import '../../data/models/models.dart';

class LobbyRepository {
  Future<LobbyStatusUI> processLobbyStatusToUIModel(
      LobbyStatus lobbyStatus) async {
    List<RoomUI> rooms = [];

    lobbyStatus.rooms.forEach((room) {
      rooms.add(RoomUI(name: room, key: Key(room)));
    });

    return LobbyStatusUI(
      rooms: rooms,
      leftRoomReason: lobbyStatus.leftRoomReason,
    );
  }
}
