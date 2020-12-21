import 'package:flutter/material.dart';

class EstimatedTaskInfoUI {
  final String taskId;
  final int average;
  final int median;
  final int estimatesReceived;
  final int estimatesExpected;
  final Map<int, int> estimatesDistribution;

  const EstimatedTaskInfoUI(
      {@required this.taskId,
      this.average,
      this.median,
      this.estimatesReceived,
      this.estimatesExpected,
      this.estimatesDistribution});
}
