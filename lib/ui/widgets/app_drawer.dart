import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login/bloc.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Scrum Poker'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Disconnect'),
              onTap: () {
                BlocProvider.of<LoginBloc>(context)
                    .add(LoginDisconnectFromServerE());
              }),
        ],
      ),
    );
  }
}
