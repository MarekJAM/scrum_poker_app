import 'package:flutter/material.dart';

class EstimatedTaskInfo {
  final String taskId;
  final int average;
  final int median;
  final int estimatesReceived;
  final int estimatesExpected;

  const EstimatedTaskInfo({@required this.taskId, this.average, this.median, this.estimatesReceived, this.estimatesExpected});
}