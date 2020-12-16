import 'package:flutter/material.dart';

abstract class UserCardModel {
  final String username;

  UserCardModel({@required this.username});
}

class EstimatorCardModel extends UserCardModel {
  final bool isAdmin;
  bool isInRoom;
  int estimate;

  EstimatorCardModel({
    @required String username,
    this.estimate,
    this.isAdmin = false,
    this.isInRoom = false,
  }) : super(username: username);
}

class SpectatorCardModel extends UserCardModel {
  SpectatorCardModel({
    @required String username,
  }) : super(username: username);
}
