import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens.dart';
import '../../ui/widgets/common/widgets.dart';
import '../../configurable/keys.dart';
import '../../bloc/auth/login/login_bloc.dart';
import '../../configurable/custom_colors.dart';
import '../../configurable/asset_paths.dart';
import '../../bloc/auth/register/register_bloc.dart';
import '../../utils/session_data_singleton.dart';
import '../../utils/debouncer.dart';
import '../../configurable/app_config.dart';
import '../../utils/hash.dart';

enum LoginMode { Regular, AsGuest }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _serverController = TextEditingController(
    text: "${AppConfig.serverIp}:${AppConfig.port}",
  );
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginMode _loginMode = LoginMode.Regular;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _userController.text = SessionDataSingleton().getUsername();
    _serverController.text = SessionDataSingleton().getServerAddress();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetPaths.logoPNG,
                    width: deviceSize.width * 0.6,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: MultiBlocListener(
                          listeners: [
                            BlocListener<RegisterBloc, RegisterState>(
                              listener: (context, state) {
                                if (state is RegisterSignedUp) {
                                  CommonWidgets.displaySnackBar(
                                    context: context,
                                    message: "Signed up successfully",
                                    color: CustomColors.snackBarSuccess,
                                  );
                                }
                              },
                            ),
                            BlocListener<LoginBloc, LoginState>(
                              listener: (ctx, state) {
                                if (state is LoginConnectionError) {
                                  CommonWidgets.displaySnackBar(
                                    context: ctx,
                                    message: state.message,
                                    color: CustomColors.snackBarError,
                                    lightText: true,
                                  );
                                }
                              },
                            ),
                          ],
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                key: Key(Keys.inputServerAddress),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Server address',
                                  prefixIcon: Icon(
                                    Icons.dns,
                                  ),
                                ),
                                controller: _serverController,
                                onChanged: (value) {
                                  _debouncer.run(() => SessionDataSingleton()
                                      .setServerAddress(value.trim()));
                                },
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Provide server address.";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                key: Key(Keys.inputUsername),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                controller: _userController,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Provide username.";
                                  } else if (value.trim().length > 20) {
                                    return "Name too long - max. 20 characters.";
                                  }
                                  return null;
                                },
                              ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 450),
                                curve: Curves.easeInOutBack,
                                child: Container(
                                  child: _loginMode == LoginMode.AsGuest
                                      ? null
                                      : Column(
                                          children: [
                                            TextFormField(
                                              key: Key(Keys.inputPassword),
                                              decoration: InputDecoration(
                                                labelText: 'Password',
                                                prefixIcon: Icon(Icons.lock),
                                              ),
                                              obscureText: true,
                                              controller: _passwordController,
                                              validator: (value) {
                                                if (value.trim().isEmpty) {
                                                  return "Provide password.";
                                                } else if (value.trim().length >
                                                    20) {
                                                  return "Password too long - max. 20 characters.";
                                                }
                                                return null;
                                              },
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                    ),
                                                    padding:
                                                        MaterialStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RecoverPasswordScreen(
                                                          passedServerAddress:
                                                              _serverController
                                                                  .text
                                                                  .trim(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Forgot password?',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: double.infinity,
                                ),
                                child: TextButton(
                                  key: Key(Keys.buttonConnect),
                                  child: Text(
                                    _loginMode == LoginMode.Regular
                                        ? 'Login'
                                        : 'Login as Guest',
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      FocusScope.of(context).unfocus();
                                      _onFormSubmitted();
                                    }
                                  },
                                ),
                              ),
                              Divider(),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                                child: Text(_loginMode == LoginMode.Regular
                                    ? 'Continue as Guest'
                                    : 'Go Back'),
                                onPressed: () {
                                  setState(
                                    () {
                                      _loginMode =
                                          _loginMode == LoginMode.AsGuest
                                              ? LoginMode.Regular
                                              : LoginMode.AsGuest;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          CustomColors.buttonGrey,
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: CustomColors.textDark),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              passedServerAddress:
                                  _serverController.text.trim(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginConnectingToServer) {
                    return LoadingLayer();
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    _loginMode == LoginMode.Regular
        ? BlocProvider.of<LoginBloc>(context).add(
            LoginConnectToServerE(
              serverAddress: _serverController.text.trim(),
              username: _userController.text.trim(),
              password: Hash.encrypt(_passwordController.text.trim()),
            ),
          )
        : BlocProvider.of<LoginBloc>(context).add(
            LoginConnectToServerE(
              serverAddress: _serverController.text.trim(),
              username: _userController.text.trim(),
              isLoggingAsGuest: true,
            ),
          );
  }
}
