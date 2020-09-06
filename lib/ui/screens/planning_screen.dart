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
    var estimatedTask = "";
    var amAdmin = false;

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
                            child: BlocBuilder<PlanningRoomBloc,
                                PlanningRoomState>(builder: (_, state) {
                              if (state is PlanningRoomRoomStatusLoaded) {
                                estimatedTask =
                                    state.roomStatus.estimateRequest;
                                amAdmin = state.amAdmin;
                              }
                              return amAdmin
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildTaskEstimateText(
                                            context, estimatedTask),
                                        RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Request Estimate',
                                          ),
                                          onPressed: () {
                                            _showRequestEstimateDialog(context);
                                          },
                                        )
                                      ],
                                    )
                                  : _buildTaskEstimateText(
                                      context, estimatedTask);
                            }),
                          ),
                          height: deviceSize.height * 0.1,
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
      var users = state.roomStatus.admins + state.roomStatus.users;
      return Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: [
          for (var user in users)
            Container(
              width: deviceSize.width * 1 / 3,
              child: Card(
                child: ListTile(
                  // leading: Icon(Icons.star),
                  title: Text(user),
                  trailing: Text('1'),
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

  Widget _buildTaskEstimateText(BuildContext context, String taskNumber) {
    return Flexible(
      child: Text(
        'Task: $taskNumber',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void _showRequestEstimateDialog(BuildContext context) {
    TextEditingController _taskController = TextEditingController();
    final _reqestEstimateKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _reqestEstimateKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Task number"),
                        controller: _taskController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Provide task number.";
                          }
                          return null;
                        },
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Send request"),
                      onPressed: () {
                        if (_reqestEstimateKey.currentState.validate()) {
                          BlocProvider.of<PlanningRoomBloc>(context).add(
                            PlanningRoomSendEstimateRequestE(
                              _taskController.text,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
