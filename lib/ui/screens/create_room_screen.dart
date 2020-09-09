import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/ui/screens/screens.dart';
import '../../bloc/room_connection/bloc.dart';
import '../../data/repositories/repositories.dart';

class CreateRoomScreen extends StatelessWidget {
  static const routeName = '/createRoom';

  @override
  Widget build(BuildContext context) {
    TextEditingController _roomController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => RoomConnectionBloc(
          roomsRepository: RepositoryProvider.of<RoomsRepository>(context)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: FlatButton(
                child: Icon(Icons.arrow_back, color: Theme.of(context).canvasColor),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LobbyScreen.routeName);
                },
              ),
            ),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Room name"),
                        controller: _roomController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Provide room name.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          BlocConsumer<RoomConnectionBloc, RoomConnectionState>(
                        listener: (_, state) {
                          if (state is RoomConnectionConnectedToRoom) {
                            Navigator.of(context).pushReplacementNamed(
                              PlanningScreen.routeName,
                              arguments: _roomController.text,
                            );
                          }
                        },
                        builder: (_, state) {
                          return Column(
                            children: [
                              if (state is RoomConnectionError)
                                Container(
                                  child: Text(
                                    state.message,
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor),
                                  ),
                                ),
                              state is RoomConnectionConnecting
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : RaisedButton(
                                      child: Text(
                                        "Create",
                                        style: TextStyle(
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          BlocProvider.of<RoomConnectionBloc>(
                                                  context)
                                              .add(
                                            RoomConnectionCreateRoomE(
                                              _roomController.text,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
