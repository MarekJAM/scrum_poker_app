import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrum_poker_app/bloc/planning/bloc.dart';
import 'package:scrum_poker_app/bloc/planning/websocket_bloc.dart';
import 'package:scrum_poker_app/bloc/planning/websocket_event.dart';
import 'package:scrum_poker_app/ui/screens/screens.dart';
import './bloc/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  WebSocketChannel channel;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WebSocketBloc>(
          create: (context) => WebSocketBloc(
            channel: channel,
          ),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (_, state) {
          if (state is WSConnectedToServer || state is WSMessageLoaded || state is WSMessageLoaded) {
            return RoomsScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        RoomsScreen.routeName: (ctx) => RoomsScreen(),
        PlanningScreen.routeName: (ctx) => PlanningScreen(),
      },
    );
  }
}
