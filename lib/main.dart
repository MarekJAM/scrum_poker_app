import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/rooms/bloc.dart';
import './bloc/websocket/bloc.dart';
import './bloc/login/bloc.dart';
import './bloc/websocket/websocket_bloc.dart';
import './ui/screens/screens.dart';
import './bloc/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './data/repositories/repositories.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = SimpleBlocObserver();

  WebSocketChannel channel;
  final webSocketRepository = WebSocketRepository();

  final RoomsRepository roomsRepository = RoomsRepository(
      roomsApiClient: RoomsApiClient(httpClient: http.Client()));

  // ignore: close_sinks
  final webSocketBloc =
      WebSocketBloc(channel: channel, webSocketRepository: webSocketRepository);
  // ignore: close_sinks
  final roomsBloc =
      RoomsBloc(webSocketBloc: webSocketBloc, roomsRepository: roomsRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<WebSocketBloc>(
          create: (context) => webSocketBloc,
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(webSocketBloc: webSocketBloc),
        ),
        BlocProvider<RoomsBloc>(
          create: (context) => roomsBloc,
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginConnectedToServer) {
          Navigator.of(context).pushReplacementNamed(RoomsScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      },
      child: MaterialApp(
        title: title,
        home: LoginScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RoomsScreen.routeName: (ctx) => RoomsScreen(),
          PlanningScreen.routeName: (ctx) => PlanningScreen(),
        },
      ),
    );
  }
}
