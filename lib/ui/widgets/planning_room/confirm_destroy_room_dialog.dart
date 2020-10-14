import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/room_connection/bloc.dart';
import '../../../utils/keys.dart';

class ConfirmDestroyRoomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Are you sure you want to destroy the room?',
                textAlign: TextAlign.center,
              ),
            ),
            BlocBuilder<RoomConnectionBloc, RoomConnectionState>(
                builder: (context, state) {
              if (state is RoomConnectionDestroyingRoom) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    key: Key(Keys.buttonDestroyRoomConfirm),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Yes",
                    ),
                    onPressed: () {
                      BlocProvider.of<RoomConnectionBloc>(context).add(
                        RoomConnectionDestroyRoomE(),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
