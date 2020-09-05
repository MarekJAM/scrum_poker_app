import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/planning_room/bloc.dart';
import '../../data/repositories/repositories.dart';
import '../../bloc/room_connection/bloc.dart';
import '../../ui/screens/rooms_screen.dart';

class PlanningScreen extends StatelessWidget {
  static const routeName = '/planning';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final roomName = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
        create: (BuildContext context) => RoomConnectionBloc(
              roomsRepository: RepositoryProvider.of<RoomsRepository>(context),
            ),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: FlatButton(
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).buttonColor,
                ),
                onPressed: () {
                  BlocProvider.of<RoomConnectionBloc>(context).add(
                    RoomConnectionDisconnectFromRoomE(),
                  );
                },
              ),
              title: Text(roomName),
            ),
            body: BlocListener<RoomConnectionBloc, RoomConnectionState>(
              listener: (ctx, state) {
                if (state is RoomConnectionDisconnectedFromRoom) {
                  Navigator.of(context)
                      .pushReplacementNamed(RoomsScreen.routeName);
                }
              },
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
                        builder: (_, state) {
                          if (state is PlanningRoomRoomiesLoaded) {
                            var users =
                                state.roomies.admins + state.roomies.users;
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(users[index]),
                                    // trailing: Text("${users[key]}"),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    VerticalDivider(),
                    Container(
                      width: deviceSize.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Task: CS-512',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text('Average: 4.5'),
                          Text('Median: 4'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
