import 'package:flutter/material.dart';

class UserEstimationCard {
  final String username;
  final bool isAdmin;
  bool isInRoom;
  int estimate;

  UserEstimationCard({@required this.username, this.estimate, this.isAdmin = false, this.isInRoom = false});
}