import 'package:flutter/material.dart';

import 'ui_models.dart';

class PlanningRoomStatusInfo {
  final EstimatedTaskInfo estimatedTaskInfo;
  final bool amAdmin;
  final bool alreadyEstimated;
  final List<EstimatorCardModel> estimatorCards;
  final List<SpectatorCardModel> spectatorCards;
  final bool amSpectator;

  PlanningRoomStatusInfo({
    @required this.estimatedTaskInfo,
    @required this.amAdmin,
    @required this.alreadyEstimated,
    @required this.estimatorCards,
    @required this.spectatorCards,
    this.amSpectator = false,
  });
}
