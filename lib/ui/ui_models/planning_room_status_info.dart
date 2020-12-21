import 'package:flutter/material.dart';

import 'ui_models.dart';

class PlanningRoomStatusInfoUI {
  final EstimatedTaskInfoUI estimatedTaskInfo;
  final bool amAdmin;
  final bool alreadyEstimated;
  final List<EstimatorCardModelUI> estimatorCards;
  final List<SpectatorCardModelUI> spectatorCards;
  final bool amSpectator;

  PlanningRoomStatusInfoUI({
    @required this.estimatedTaskInfo,
    @required this.amAdmin,
    @required this.alreadyEstimated,
    @required this.estimatorCards,
    @required this.spectatorCards,
    this.amSpectator = false,
  });
}
