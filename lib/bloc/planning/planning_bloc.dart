import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'bloc.dart';

class PlanningBloc extends Bloc<PlanningEvent, PlanningState> {
  IOWebSocketChannel channel;

  PlanningBloc({@required this.channel}) : super(PlanningInitial());

  @override
  Stream<PlanningState> mapEventToState(PlanningEvent event) async* {
    if (event is ConnectToServer) {
      yield* _mapConnectToServerToState(event);
    } else if (event is MessageRecieved) {
      yield* _mapMessageRecievedToState(event);
    } else if (event is SendMessage) {
      yield* _mapSendMessageToState(event);
    } else if (event is DisconnectedFromServer) {
      yield* _mapDisconnectFromServerToState(event);
    }
  }

  Stream<PlanningState> _mapConnectToServerToState(event) async* {
    try {
      channel = IOWebSocketChannel.connect(event.link);
      channel.stream.listen((message) {
        add(MessageRecieved(message));
      }, onError: (e) {
        print(e);
      });
      yield ConnectedToServer(message: "Connected to server");
    } catch (e) {
      print(e);
    }
  }

  Stream<PlanningState> _mapSendMessageToState(event) async* {
    try {
      channel.sink.add(event.message);
    } catch (e) {
      print(e);
    }
  }

  Stream<PlanningState> _mapDisconnectFromServerToState(event) async* {
    try {
      channel.sink.close();
      yield DisconnectedFromServer(message: "Disconnected from server");
    } catch (e) {
      print(e);
    }
  }

  Stream<PlanningState> _mapMessageRecievedToState(event) async* {
    yield MessageLoading();
    try {
      yield MessageLoaded(message: "Message recieved: ${event.message}");
    } catch (e) {
      print(e);
    }
  }
}
