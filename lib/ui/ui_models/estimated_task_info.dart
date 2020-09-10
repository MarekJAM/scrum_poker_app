import 'package:flutter/material.dart';

class EstimatedTaskInfo {
  final String taskId;
  final double average;
  final int median;

  const EstimatedTaskInfo({@required this.taskId, this.average, this.median});
}