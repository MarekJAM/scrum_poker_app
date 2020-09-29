import 'package:flutter/material.dart';

import 'ui_models.dart';

class PlanningRoomStatusInfo {
  final EstimatedTaskInfo estimatedTaskInfo;
  final bool amAdmin;
  final bool alreadyEstimated;
  final List<UserEstimationCard> userEstimationCards;

  PlanningRoomStatusInfo({
    @required this.estimatedTaskInfo,
    @required this.amAdmin,
    @required this.alreadyEstimated,
    @required this.userEstimationCards,
  });
}
