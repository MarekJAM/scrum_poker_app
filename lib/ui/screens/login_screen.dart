import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/keys.dart';
import '../../ui/widgets/common/common_widgets.dart';
import '../../bloc/login/bloc.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _serverController = TextEditingController(
    text: "192.168.0.14:8080",
  );
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                  Text(
                    'Scrum Poker',
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline2.color,
                      fontSize: 35,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
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
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  obscureText: true,
                                  controller: _passwordController,
                                  readOnly: state is LoginConnectingToServer
                                      ? true
                                      : false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Provide password.";
                                    } else if (value.trim().length > 20) {
                                      return "Password too long - max. 20 characters.";
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
                                            'Login',
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _onFormSubmitted();
                                            }
                                          },
                                        ),
                                      ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Continue as guest'),
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
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text('Create Account'),
                    ),
                  ),
                ),
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
