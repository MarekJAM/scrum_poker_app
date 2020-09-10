import 'package:flutter/material.dart';

class EstimatedTaskInfo {
  const EstimatedTaskInfo({@required this.taskId, @required this.average, @required this.median});

  final String taskId;
  final int average;
  final int median;
}