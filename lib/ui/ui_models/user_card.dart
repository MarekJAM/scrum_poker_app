import 'package:flutter/material.dart';

abstract class UserCardModelUI {
  final String username;

  UserCardModelUI({@required this.username});
}

class EstimatorCardModelUI extends UserCardModelUI {
  final bool isAdmin;
  bool isInRoom;
  int estimate;

  EstimatorCardModelUI({
    @required String username,
    this.estimate,
    this.isAdmin = false,
    this.isInRoom = false,
  }) : super(username: username);
}

class SpectatorCardModelUI extends UserCardModelUI {
  SpectatorCardModelUI({
    @required String username,
  }) : super(username: username);
}
