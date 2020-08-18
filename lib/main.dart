import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrum_poker_app/bloc/planning/bloc.dart';
import 'package:scrum_poker_app/bloc/planning/planning_bloc.dart';
import 'package:scrum_poker_app/bloc/planning/planning_event.dart';
import './bloc/simple_bloc_observer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  WebSocketChannel channel;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlanningBloc>(
          create: (context) => PlanningBloc(
            channel: channel,
          ),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _messageController = TextEditingController();
  TextEditingController _serverController =
      TextEditingController(text: "ws://echo.websocket.org");

  _showToast(Color color, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<PlanningBloc, PlanningState>(
        listener: (_, state) {
          if (state is ConnectedToServer) {
            _showToast(Colors.blueGrey, "${state.message}");
          } else if (state is MessageLoaded) {
            _showToast(Colors.green, "${state.message}");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _serverController,
                        decoration:
                            InputDecoration(labelText: 'Connect to server'),
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.input),
                      onPressed: () =>
                          BlocProvider.of<PlanningBloc>(context).add(
                        ConnectToServer(_serverController.text),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          decoration:
                              InputDecoration(labelText: 'Send a message'),
                        ),
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.send),
                        onPressed: () =>
                            BlocProvider.of<PlanningBloc>(context).add(
                          SendMessage(_messageController.text),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
