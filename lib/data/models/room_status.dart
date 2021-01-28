import 'package:flutter/material.dart';

class RoomStatus {
  final List<String> admins;
  final List<String> estimators;
  final List<String> spectators;
  final String taskId;
  final List<Estimate> estimates;

  const RoomStatus({
    @required this.admins,
    @required this.estimators,
    @required this.spectators,
    @required this.taskId,
    @required this.estimates,
  });

  factory RoomStatus.fromJson(Map<String, dynamic> json) {
    List<String> adminsListJson = [];
    List<String> estimatorsListJson = [];
    List<String> spectatorsListJson = [];
    final taskIdJson = json["room_status"]["task"]["id"] ?? "";
    List<Estimate> estimatesJson = [];

    if (json["room_status"] != null) {
      for (var admin in json["room_status"]["users"]["admins"]) {
        adminsListJson.add(admin);
      }
      for (var user in json["room_status"]["users"]["estimators"]) {
        estimatorsListJson.add(user);
      }
      for (var spectator in json["room_status"]["users"]["spectators"]) {
        spectatorsListJson.add(spectator);
      }
      for (var estimate in json["room_status"]["task"]["estimates"]) {
        estimatesJson.add(Estimate(estimate["name"], estimate["estimate"]));
      }
    }

    return RoomStatus(
      admins: adminsListJson,
      estimators: estimatorsListJson,
      spectators: spectatorsListJson,
      taskId: taskIdJson,
      estimates: estimatesJson,
    );
  }
}

class Estimate {
  final String name;
  final int estimate;

  Estimate(this.name, this.estimate);
}
