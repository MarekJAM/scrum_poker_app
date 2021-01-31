import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/widgets/dropdown_search/dropdown_search.dart';
import '../../configurable/custom_colors.dart';
import '../../bloc/auth/register/register_bloc.dart';
import '../../ui/widgets/common/widgets.dart';
import '../../utils/hash.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  final String passedServerAddress;

  RegisterScreen({this.passedServerAddress});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  String _securityQuestion;

  List<String> suggestedQuestions = [
    "What was your favorite place to visit as a child?",
    "Who was your childhood hero?",
    "What was your childhood nickname?",
    "What is your preferred musical genre?",
    "What was your first car?",
    "What color are les tenes?",
  ];

  @override
  void initState() {
    super.initState();
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
                children: [
                  Text(
                    'Create account',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
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
                                lightText: true,
                              );
                            } else if (state is RegisterSignedUp) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
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
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
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
                                  if (value.trim().isEmpty) {
                                    return "Confirm password.";
                                  } else if (value.trim().length > 20) {
                                    return "Password too long - max. 20 characters.";
                                  } else if (value.trim() !=
                                      _passwordController.text.trim()) {
                                    return "Passwords must match.";
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                ),
                                child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  showSelectedItem: true,
                                  items: suggestedQuestions,
                                  label: "Security question",
                                  hint: "Select your security question",
                                  onChanged: (value) {
                                    _securityQuestion = value;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Choose your security question.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Answer',
                                  prefixIcon: Icon(Icons.question_answer),
                                ),
                                controller: _answerController,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return "Input answer.";
                                  } else if (value.trim().length > 20) {
                                    return "Answer too long - max. 20 characters.";
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
                                    if (_registerFormKey.currentState
                                        .validate()) {
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
      RegisterSignUpE(
        _userController.text.trim(),
        Hash.encrypt(_passwordController.text.trim()),
        _securityQuestion,
        Hash.encrypt(_answerController.text.trim()),
      ),
    );
  }
}
