import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/keys.dart';
import '../../ui/widgets/common/common_widgets.dart';
import '../../bloc/login/bloc.dart';
import '../../utils/custom_colors.dart';

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
    text: "192.168.0.14:8080",
  );
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginMode _loginMode = LoginMode.Regular;

  final String assetLogo = 'assets/skram_logo_osvg.svg';

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
                  SvgPicture.asset(
                    assetLogo,
                    semanticsLabel: 'Logo',
                    width: deviceSize.width * 0.6,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (ctx, state) {
                            if (state is LoginConnectionError) {
                              CommonWidgets.displaySnackBar(
                                context: ctx,
                                message: state.message,
                                color: Theme.of(ctx).errorColor,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginDisconnectedFromServer) {
                              _userController.text = state.username;
                              _serverController.text = state.serverAddress;
                            }
                            return Column(
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
                                  readOnly: state is LoginConnectingToServer
                                      ? true
                                      : false,
                                  controller: _serverController,
                                  validator: (value) {
                                    if (value.isEmpty) {
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
                                  readOnly: state is LoginConnectingToServer
                                      ? true
                                      : false,
                                  controller: _userController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Provide username.";
                                    } else if (value.trim().length > 20) {
                                      return "Name too long - max. 20 characters.";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                state is LoginConnectingToServer
                                    ? CircularProgressIndicator()
                                    : ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minWidth: double.infinity,
                                        ),
                                        child: RaisedButton(
                                          key: Key(Keys.buttonConnect),
                                          child: Text(
                                            _loginMode == LoginMode.Regular
                                                ? 'Login'
                                                : 'Login as Guest',
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _onFormSubmitted();
                                            }
                                          },
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormSubmitted() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginConnectToServerE(_serverController.text, _userController.text),
    );
  }
}
