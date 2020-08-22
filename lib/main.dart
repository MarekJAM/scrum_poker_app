import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/websocket/bloc.dart';
import './bloc/login/bloc.dart';
import './bloc/websocket/websocket_bloc.dart';
import './ui/screens/screens.dart';
import './bloc/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './data/repositories/repositories.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  WebSocketChannel channel;
  final webSocketRepository = WebSocketRepository();

  final webSocketBloc = WebSocketBloc(channel: channel, webSocketRepository: webSocketRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WebSocketBloc>(
          create: (context) => webSocketBloc,
        ),
        BlocProvider(
          create: (context) => LoginBloc(webSocketBloc: webSocketBloc),
        )
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
      home: BlocBuilder<LoginBloc, LoginState>(
        builder: (_, state) {
          if (state is LoginConnectedToServer) {
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
