import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  @override
  List<Object> get props => [];
}

class NavigatorInitial extends NavigatorEvent {
  @override
  String toString() => 'NavigatorInitial';
}

class NavigateToLoginScreenE extends NavigatorEvent {
  @override
  String toString() => 'NavigateToLoginScreenE';
}

class NavigateToRoomsScreenE extends NavigatorEvent {
  @override
  String toString() => 'NavigateToRoomsScreenE';
}

