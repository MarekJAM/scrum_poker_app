import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/custom_colors.dart';
import '../../bloc/auth/register/register_bloc.dart';
import '../../ui/widgets/common/widgets.dart';
import '../../utils/custom_colors.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  final String passedServerAddress;

  RegisterScreen({this.passedServerAddress});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController _serverController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _serverController.text = widget.passedServerAddress ?? "";
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
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _registerFormKey,
                    child: BlocListener<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterSignUpError) {
                          CommonWidgets.displaySnackBar(
                            context: context,
                            message: state.message,
                            color: CustomColors.snackBarError,
                            lightText: true
                          );
                        } else if (state is RegisterSignedUp) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Server address',
                              prefixIcon: Icon(
                                Icons.dns,
                              ),
                            ),
                            controller: _serverController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Provide server address.";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                            ),
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Provide password.";
                              } else if (value.trim().length > 20) {
                                return "Password too long - max. 20 characters.";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Confirm password.";
                              } else if (value.trim().length > 20) {
                                return "Password too long - max. 20 characters.";
                              } else if (value != _passwordController.text) {
                                return "Passwords must match.";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: RaisedButton(
                              child: Text(
                                'Sign Up',
                              ),
                              onPressed: () {
                                if (_registerFormKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _onFormSubmitted();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                      color: CustomColors.buttonGrey,
                      child: Text(
                        'Back',
                        style: TextStyle(color: CustomColors.textDark),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  if (state is RegisterSigningUp) {
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
    BlocProvider.of<RegisterBloc>(context).add(
      RegisterSignUpE(_serverController.text, _userController.text,
          _passwordController.text),
    );
  }
}
