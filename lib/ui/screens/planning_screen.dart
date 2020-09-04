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

    final planningBloc = BlocProvider.of<PlanningRoomBloc>(context);

    Map<String, int> users = {
      'John': 5,
      'Andrew': 2,
      'Tim': 3,
      'Samuel': 4,
      'Pit': 5,
      'Michael': 6,
      'Alex': 4,
    };

    return BlocProvider(
        create: (BuildContext context) => RoomConnectionBloc(
              roomsRepository: RepositoryProvider.of<RoomsRepository>(context),
            ),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: FlatButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  BlocProvider.of<RoomConnectionBloc>(context).add(
                    RoomConnectionDisconnectFromRoomE(),
                  );
                },
              ),
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
                        cubit: planningBloc,
                        builder: (_, state) {
                          if (state is PlanningRoomRoomiesLoaded) {
                            var users = state.roomies.admins;
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
