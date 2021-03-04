import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:window_size/window_size.dart';

import './utils/custom_page_transition_builder.dart';
import './bloc/room_connection/room_connection_bloc.dart';
import './bloc/planning_room/planning_room_bloc.dart';
import './bloc/lobby/lobby_bloc.dart';
import './bloc/websocket/websocket_bloc.dart';
import './bloc/auth/login/login_bloc.dart';
import './ui/screens/screens.dart';
import './bloc/simple_bloc_observer.dart';
import './data/repositories/repositories.dart';
import './ui/widgets/common/common_widgets.dart';
import './bloc/auth/register/register_bloc.dart';
import './bloc/auth/recovery/recovery_bloc.dart';
import 'configurable/custom_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(450, 700));
  }

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US'],
  );

  Bloc.observer = SimpleBlocObserver();

  WebSocketChannel channel;
  final webSocketRepository = WebSocketRepository();

  final RoomsRepository roomsRepository = RoomsRepository(
      roomsApiClient: RoomsApiClient(httpClient: http.Client()));

  final PlanningRoomRepository planningRoomRepository =
      PlanningRoomRepository();

  final AuthRepository authRepository =
      AuthRepository(authApiClient: AuthApiClient(httpClient: http.Client()));

  final LobbyRepository lobbyRepository = LobbyRepository();

  // ignore: close_sinks
  final webSocketBloc =
      WebSocketBloc(channel: channel, webSocketRepository: webSocketRepository);
  // ignore: close_sinks
  final roomsBloc =
      LobbyBloc(webSocketBloc: webSocketBloc, lobbyRepository: lobbyRepository);
  // ignore: close_sinks
  final loginBloc =
      LoginBloc(webSocketBloc: webSocketBloc, authRepository: authRepository);
  // ignore: close_sinks
  final planningRoomBloc = PlanningRoomBloc(
      webSocketBloc: webSocketBloc,
      planningRoomRepository: planningRoomRepository);
  // ignore: close_sinks
  final roomConnectionBloc =
      RoomConnectionBloc(roomsRepository: roomsRepository);
  // ignore: close_sinks
  final registerBloc = RegisterBloc(authRepository: authRepository);
  // ignore: close_sinks
  final recoveryBloc = RecoveryBloc(authRepository: authRepository);

  runApp(
    LocalizedApp(
      delegate,
      App(
        webSocketBloc: webSocketBloc,
        roomsBloc: roomsBloc,
        loginBloc: loginBloc,
        roomsRepository: roomsRepository,
        planningRoomBloc: planningRoomBloc,
        roomConnectionBloc: roomConnectionBloc,
        authRepository: authRepository,
        registerBloc: registerBloc,
        recoveryBloc: recoveryBloc,
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.webSocketBloc,
    @required this.roomsBloc,
    @required this.loginBloc,
    @required this.roomsRepository,
    @required this.planningRoomBloc,
    @required this.roomConnectionBloc,
    @required this.authRepository,
    @required this.registerBloc,
    @required this.recoveryBloc,
  }) : super(key: key);

  final WebSocketBloc webSocketBloc;
  final LobbyBloc roomsBloc;
  final LoginBloc loginBloc;
  final RoomsRepository roomsRepository;
  final PlanningRoomBloc planningRoomBloc;
  final RoomConnectionBloc roomConnectionBloc;
  final AuthRepository authRepository;
  final RegisterBloc registerBloc;
  final RecoveryBloc recoveryBloc;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => roomsRepository,
        ),
        RepositoryProvider(
          create: (context) => authRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WebSocketBloc>(
            create: (context) => webSocketBloc,
          ),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
                webSocketBloc: webSocketBloc, authRepository: authRepository),
          ),
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(authRepository: authRepository),
          ),
          BlocProvider<LobbyBloc>(
            create: (context) => roomsBloc,
          ),
          BlocProvider<PlanningRoomBloc>(
            create: (context) => planningRoomBloc,
          ),
          BlocProvider<RoomConnectionBloc>(
            create: (context) => roomConnectionBloc,
          ),
        ],
        child: AppView(),
      ),
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
    final title = 'Scrum Poker';
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return MaterialApp(
        title: title,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF292B3D),
          accentColor: Color(0xFFE07A5F),
          buttonColor: Color(0xFFE07A5F),
          scaffoldBackgroundColor: Color(0xFF3D405B),
          textSelectionHandleColor: Color(0xFFE07A5F),
          cardColor: Color(0xFFE07A5F),
          dialogBackgroundColor: Color(0xFF3D405B),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder()
            },
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return Scaffold(
            body: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginConnectedToServer) {
                  _navigator.pushAndRemoveUntil<void>(
                    LobbyScreen.route(),
                    (route) => false,
                  );
                } else if (state is LoginDisconnectedFromServer) {
                  _navigator.pushAndRemoveUntil<void>(
                    LoginScreen.route(),
                    (route) => false,
                  );
                  if (state.message.isNotEmpty) {
                    CommonWidgets.displaySnackBar(
                      context: context,
                      message: state.message,
                      color: CustomColors.snackBarError,
                      lightText: true,
                    );
                  }
                }
              },
              child: child,
            ),
          );
        },
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          LobbyScreen.routeName: (ctx) => LobbyScreen(),
          PlanningScreen.routeName: (ctx) => PlanningScreen(),
          CreateRoomScreen.routeName: (ctx) => CreateRoomScreen(),
          RecoverPasswordScreen.routeName: (ctx) => RecoverPasswordScreen(),
        },
        onGenerateRoute: (_) => SplashScreen.route());
  }
}
