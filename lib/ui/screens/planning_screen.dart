import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/bloc/rooms/rooms_bloc.dart';
import 'package:scrum_poker_app/bloc/rooms/rooms_state.dart';
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
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: FlatButton(
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).buttonColor,
                ),
                onPressed: () {
                  _leaveRoom(context);
                },
              ),
              title: Text(roomName),
            ),
            body: MultiBlocListener(
              listeners: [
                //handles navigating to room list screen
                BlocListener<RoomConnectionBloc, RoomConnectionState>(
                  listener: (context, state) {
                    if (state is RoomConnectionDisconnectedFromRoom) {
                      Navigator.of(context)
                          .pushReplacementNamed(RoomsScreen.routeName);
                    }
                  },
                ),
                //handles situation when room gets disbanded
                BlocListener<RoomsBloc, RoomsState>(
                  listener: (context, state) {
                    if (state is RoomsLoaded) {
                      Navigator.of(context)
                          .pushReplacementNamed(RoomsScreen.routeName);
                    }
                  },
                ),
              ],
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
                            builder: (_, state) {
                              return _buildUserList(context, state);
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
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      padding: EdgeInsets.all(3),
                      height: deviceSize.height * 0.12,
                      width: deviceSize.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            print('$index');
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              child: Center(
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              width: deviceSize.width * 0.12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _leaveRoom(BuildContext context) {
    BlocProvider.of<RoomConnectionBloc>(context).add(
      RoomConnectionDisconnectFromRoomE(),
    );
  }

  Widget _buildUserList(BuildContext context, state) {
    if (state is PlanningRoomRoomiesLoaded) {
      var users = state.roomies.admins + state.roomies.users;
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
  }
}
