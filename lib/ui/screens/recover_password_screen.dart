import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/recovery/recovery_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../configurable/custom_colors.dart';
import '../../ui/widgets/common/widgets.dart';
import '../../utils/hash.dart';

class RecoverPasswordScreen extends StatefulWidget {
  static const routeName = '/recovery';
  final String passedServerAddress;

  RecoverPasswordScreen({this.passedServerAddress});

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _recoveryFormKey = GlobalKey<FormState>();

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider<RecoveryBloc>(
        create: (context) => RecoveryBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Password recovery',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _recoveryFormKey,
                          child: BlocConsumer<RecoveryBloc, RecoveryState>(
                            listener: (context, state) {
                              if (state is RecoveryError) {
                                CommonWidgets.displaySnackBar(
                                  context: context,
                                  message: state.message,
                                  color: CustomColors.snackBarError,
                                  lightText: true,
                                );
                              }
                            },
                            buildWhen: (_, state) {
                              if (state is RecoveryError ||
                                  state is RecoveryInitial ||
                                  state is RecoveryLoading) {
                                return false;
                              }
                              return true;
                            },
                            builder: (context, state) {
                              if (state is RecoveryStepThreeDone) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.done,
                                        color: Colors.green,
                                        size: 60,
                                      ),
                                      Text('Password has been changed.')
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (state is RecoveryInitial)
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
                                  if (state is RecoveryStepOneDone)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Question',
                                        prefixIcon: Icon(
                                            Icons.question_answer_outlined),
                                      ),
                                      key: Key('question'),
                                      enabled: false,
                                      initialValue: state.question,
                                    ),
                                  if (state is RecoveryStepOneDone)
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
                                  if (state is RecoveryStepTwoDone)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'New Password',
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
                                  if (state is RecoveryStepTwoDone)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Confirm New Password',
                                        prefixIcon: Icon(Icons.lock),
                                      ),
                                      obscureText: true,
                                      controller: _confirmPasswordController,
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return "Confirm new password.";
                                        } else if (value.trim().length > 20) {
                                          return "Password too long - max. 20 characters.";
                                        } else if (value !=
                                            _passwordController.text.trim()) {
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
                                    child: ElevatedButton(
                                      child: Text(
                                        _getButtonText(state),
                                      ),
                                      onPressed: () {
                                        if (_recoveryFormKey.currentState
                                            .validate()) {
                                          FocusScope.of(context).unfocus();
                                          if (state is RecoveryInitial) {
                                            BlocProvider.of<RecoveryBloc>(
                                                    context)
                                                .add(
                                              RecoveryStart(
                                                username:
                                                    _userController.text.trim(),
                                              ),
                                            );
                                          } else if (state
                                              is RecoveryStepOneDone) {
                                            BlocProvider.of<RecoveryBloc>(
                                                    context)
                                                .add(
                                              RecoverySendAnswer(
                                                answer: Hash.encrypt(
                                                    _answerController.text
                                                        .trim()),
                                              ),
                                            );
                                          } else if (state
                                              is RecoveryStepTwoDone) {
                                            BlocProvider.of<RecoveryBloc>(
                                                    context)
                                                .add(
                                              RecoverySendPassword(
                                                password: Hash.encrypt(
                                                    _passwordController.text
                                                        .trim()),
                                              ),
                                            );
                                          }
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
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.buttonGrey)),
                        child: Text(
                          'Return to login screen',
                          style: TextStyle(color: CustomColors.textDark),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                BlocBuilder<RecoveryBloc, RecoveryState>(
                  builder: (context, state) {
                    if (state is RecoveryLoading) {
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
      ),
    );
  }

  String _getButtonText(RecoveryState state) {
    if (state is RecoveryInitial) {
      return "Recover password";
    } else if (state is RecoveryStepOneDone) {
      return "Answer";
    } else if (state is RecoveryStepTwoDone) {
      return "Change password";
    }
    return "";
  }
}
