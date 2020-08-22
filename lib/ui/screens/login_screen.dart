import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login/bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _serverController =
      TextEditingController(text: "ws://192.168.0.14:8080");
  TextEditingController _userController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 127, 80, 1).withOpacity(0.5),
                    Colors.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Scrum Poker',
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline2.color,
                        fontSize: 35,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Center(
                      child: Card(
                        margin: EdgeInsets.all(30),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: BlocConsumer<LoginBloc, LoginState>(
                              listener: (ctx, state) {
                                if (state is LoginConnectionError) {
                                  Scaffold.of(ctx).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Theme.of(ctx).errorColor,
                                      content: Text(state.message),
                                    ),
                                  );
                                } 
                              },
                              builder: (_, state) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText: 'Server address',
                                          prefixIcon: Icon(Icons.dns)),
                                      readOnly: state is LoginConnectingToServer ? true : false,
                                      controller: _serverController,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                      readOnly: state is LoginConnectingToServer ? true : false,
                                      controller: _userController,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    state is LoginConnectingToServer
                                        ? CircularProgressIndicator()
                                        : RaisedButton(
                                            child: Text('Connect'),
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            onPressed: () {
                                              _onFormSubmitted();
                                            },
                                          )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor);
  }

  void _onFormSubmitted() {
    BlocProvider.of<LoginBloc>(context)
        .add(LoginConnectToServerE(_serverController.text));
  }
}
