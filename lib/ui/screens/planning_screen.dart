import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/rooms/bloc.dart';
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
    final estimates = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      20,
      25,
      30,
      40,
      50
    ];

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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: Center(
                              child: Text(
                            'Task: CS-345',
                            style: TextStyle(fontSize: 20),
                          )),
                          height: deviceSize.height * 0.1,
                          width: deviceSize.width * 0.8,
                        ),
                      ),
                      Divider(),
                      Container(
                        width: double.infinity,
                        child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
                          builder: (_, state) {
                            return _buildUserList(context, state, deviceSize);
                          },
                        ),
                      ),
                    ],
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
                        itemCount: estimates.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            print('$index');
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                              child: Center(
                                child: Text(
                                  '${estimates[index]}',
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

  Widget _buildUserList(BuildContext context, state, Size deviceSize) {
    if (state is PlanningRoomRoomStatusLoaded) {
      print(state.roomStatus.estimateRequest);
      var users = state.roomStatus.admins + state.roomStatus.users;
      return Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: [
          for (var user in users)
            Container(
              width: deviceSize.width * 1/3,
              child: Card(
                child: ListTile(
                  // leading: Icon(Icons.star),
                  title: Text(user),
                  // trailing: Text("${users[key]}"),
                ),
              ),
            ),
        ],
      );
    } else {
      return Container();
    }
  }
}
