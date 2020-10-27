import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/screens/screens.dart';
import '../../bloc/room_connection/bloc.dart';
import '../../utils/keys.dart';

class CreateRoomScreen extends StatelessWidget {
  static const routeName = '/createRoom';

  @override
  Widget build(BuildContext context) {
    TextEditingController _roomController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
            child: Icon(Icons.arrow_back),
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
                    if (value.isEmpty) {
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
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                        state is RoomConnectionConnecting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : RaisedButton(
                                key: Key(Keys.buttonCreateRoom),
                                child: Text(
                                  "Create",
                                ),
                                color: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
    );
  }
}
