import 'dart:io';

import 'package:flutter/foundation.dart';
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

  BlocOverrides.runZoned(
    () async {
      if (!kIsWeb) {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          var screen = await getCurrentScreen();
          setWindowMinSize(const Size(450, 700));
          setWindowMaxSize(screen.visibleFrame.size);
        }
      }

      var delegate = await LocalizationDelegate.create(
        fallbackLocale: 'en_US',
        supportedLocales: ['en_US'],
      );

      WebSocketChannel channel;
      final webSocketRepository = WebSocketRepository();

      final RoomsRepository roomsRepository = RoomsRepository(roomsApiClient: RoomsApiClient(httpClient: http.Client()));

      final PlanningRoomRepository planningRoomRepository = PlanningRoomRepository();

      final AuthRepository authRepository = AuthRepository(authApiClient: AuthApiClient(httpClient: http.Client()));

      final LobbyRepository lobbyRepository = LobbyRepository();

      final webSocketBloc = WebSocketBloc(channel: channel, webSocketRepository: webSocketRepository);
      final roomsBloc = LobbyBloc(webSocketBloc: webSocketBloc, lobbyRepository: lobbyRepository);
      final loginBloc = LoginBloc(webSocketBloc: webSocketBloc, authRepository: authRepository);
      final planningRoomBloc = PlanningRoomBloc(webSocketBloc: webSocketBloc, planningRoomRepository: planningRoomRepository);
      final roomConnectionBloc = RoomConnectionBloc(roomsRepository: roomsRepository);
      final registerBloc = RegisterBloc(authRepository: authRepository);
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
    },
    blocObserver: kDebugMode ? SimpleBlocObserver() : null,
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
            create: (context) => LoginBloc(webSocketBloc: webSocketBloc, authRepository: authRepository),
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
    final title = 'Skram';
    var localizationDelegate = LocalizedApp.of(context).delegate;
    final ThemeData theme = ThemeData();
    return MaterialApp(
        title: title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF292B3D),
            titleTextStyle: TextStyle(
              color: CustomColors.buttonLightGrey,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            iconTheme: IconThemeData(color: CustomColors.buttonLightGrey),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF292B3D),
          ),
          primaryColor: Color(0xFF292B3D),
          colorScheme: theme.colorScheme.copyWith(
            brightness: Brightness.dark,
            secondary: Color(0xFFE07A5F),
            primary: Color(0xFFE07A5F),
          ),
          buttonTheme: ButtonThemeData(
            colorScheme: theme.colorScheme.copyWith(
              primary: Color(0xFFE07A5F),
            ),
            buttonColor: Color(
              0xFFE07A5F,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFE07A5F),
              ),
            ),
          ),
          scaffoldBackgroundColor: Color(0xFF3D405B),
          cardColor: Color(0xFFE07A5F),
          dialogBackgroundColor: Color(0xFF3D405B),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder()
            },
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 35),
              ),
              backgroundColor: MaterialStateProperty.all(
                Color(0xFFE07A5F),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 35),
              ),
              backgroundColor: MaterialStateProperty.all(
                Color(0xFFE07A5F),
              ),
              foregroundColor: MaterialStateProperty.all(
                CustomColors.buttonLightGrey,
              ),
            ),
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
