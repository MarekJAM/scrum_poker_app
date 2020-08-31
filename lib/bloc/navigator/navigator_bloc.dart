import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorBloc({this.navigatorKey}) : super(NavigatorInitial());

  @override
  Stream<dynamic> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToLoginScreenE) {
      navigatorKey.currentState.pushNamed('/login');
    } else if (event is NavigateToRoomsScreenE) {
      navigatorKey.currentState.pushNamed('/rooms');
    }
  }
}
