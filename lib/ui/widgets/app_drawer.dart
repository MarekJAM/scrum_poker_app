import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/screens/screens.dart';
import '../../bloc/room_connection/room_connection_bloc.dart';
import '../../bloc/auth/login/login_bloc.dart';
import '../../configurable/keys.dart';
import '../../configurable/asset_paths.dart';
import '../../utils/session_data_singleton.dart';
import '../../configurable/versions.dart';

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
          Navigator.of(context).popUntil(
            ModalRoute.withName(PlanningScreen.routeName),
          );
        }
      },
      child: Drawer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Image.asset(
                    AssetPaths.logoPNG,
                    width: 150,
                  ),
                  accountEmail: Text(
                    'v' + Versions.appVersion,
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
                  key: Key(Keys.buttonDisconnect),
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
        ),
      ),
    );
  }
}
