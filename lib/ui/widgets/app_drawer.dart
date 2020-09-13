import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/room_connection/bloc.dart';
import '../../bloc/login/bloc.dart';

class AppDrawer extends StatelessWidget {
  final List<Widget> passedWidgets;

  AppDrawer([this.passedWidgets]);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomConnectionBloc, RoomConnectionState>(
      listenWhen: (_, state) {
        return state is RoomConnectionDestroyingRoomError ? true : false;
      },
      listener: (_, state) {
        if (state is RoomConnectionDestroyingRoomError) {
          Navigator.of(context).pop();
        }
      },
      child: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                'Scrum Poker',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              accountEmail: Text(
                'v. 1.0.0',
                style: TextStyle(fontSize: 12),
              ),
            ),
            if (passedWidgets != null && passedWidgets.length > 0)
              ...passedWidgets,
            ListTile(
              enabled: false,
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Disconnect'),
              onTap: () {
                BlocProvider.of<LoginBloc>(context)
                    .add(LoginDisconnectFromServerE());
              },
            ),
          ],
        ),
      ),
    );
  }
}
