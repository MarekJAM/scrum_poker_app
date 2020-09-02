import 'package:flutter/services.dart';
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
  // ignore: close_sinks
  final loginBloc = LoginBloc(webSocketBloc: webSocketBloc);

  runApp(
    App(
      webSocketBloc: webSocketBloc,
      roomsBloc: roomsBloc,
      loginBloc: loginBloc,
    ),
  );
}

class App extends StatelessWidget {
  const App(
      {Key key,
      @required this.webSocketBloc,
      @required this.roomsBloc,
      @required this.loginBloc})
      : super(key: key);

  final WebSocketBloc webSocketBloc;
  final RoomsBloc roomsBloc;
  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
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
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context).add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
        title: title,
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginConnectedToServer) {
                _navigator.pushAndRemoveUntil<void>(
                  RoomsScreen.route(),
                  (route) => false,
                );
              } else if (state is LoginDisconnectedFromServer) {
                _navigator.pushAndRemoveUntil<void>(
                  LoginScreen.route(),
                  (route) => false,
                );
              }
            },
            child: child,
          );
        },
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          RoomsScreen.routeName: (ctx) => RoomsScreen(),
          PlanningScreen.routeName: (ctx) => PlanningScreen(),
        },
        onGenerateRoute: (_) => SplashScreen.route());
  }
}
