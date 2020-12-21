import 'package:flutter/material.dart';

class LobbyStatusUI {
  List<RoomUI> rooms;
  final String leftRoomReason;

  LobbyStatusUI({@required this.rooms, this.leftRoomReason = ""});
}

class RoomUI {
  final String name;
  final Key key;

  RoomUI({@required this.name, @required this.key});
}
