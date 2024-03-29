import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/room_connection/room_connection_bloc.dart';
import '../../configurable/keys.dart';
import '../../ui/widgets/common/widgets.dart';

class CreateRoomScreen extends StatelessWidget {
  static const routeName = '/createRoom';

  @override
  Widget build(BuildContext context) {
    TextEditingController _roomController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
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
                      key: Key(Keys.inputRoomname),
                      decoration: InputDecoration(labelText: "Room name"),
                      controller: _roomController,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return "Provide room name.";
                        } else if (value.trim().length > 20) {
                          return "Name too long - max. 20 characters.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<RoomConnectionBloc, RoomConnectionState>(
                      builder: (_, state) {
                        return Column(
                          children: [
                            if (state is RoomConnectionError)
                              Container(
                                child: Text(
                                  state.message,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            TextButton(
                              key: Key(Keys.buttonCreateRoom),
                              child: Text(
                                "Create",
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  BlocProvider.of<RoomConnectionBloc>(context)
                                      .add(
                                    RoomConnectionCreateRoomE(
                                      _roomController.text.trim(),
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
        ),
        BlocBuilder<RoomConnectionBloc, RoomConnectionState>(
          builder: (_, state) {
            if (state is RoomConnectionConnecting) {
              return LoadingLayer();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
