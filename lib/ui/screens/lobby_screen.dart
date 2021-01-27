import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/lobby/lobby_bloc.dart';
import '../widgets/app_drawer.dart';
import '../../bloc/room_connection/room_connection_bloc.dart';
import 'screens.dart';
import '../../ui/widgets/common/widgets.dart';
import '../../configurable/keys.dart';
import '../../configurable/custom_colors.dart';
import '../../ui/ui_models/ui_models.dart';

class LobbyScreen extends StatelessWidget {
  static const routeName = '/rooms';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyScreen());
  }

  @override
  Widget build(BuildContext context) {
    List<RoomUI> rooms = [];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            key: Key(Keys.titleLobby),
            title: Text('Lobby'),
          ),
          drawer: AppDrawer(),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: BlocListener<RoomConnectionBloc, RoomConnectionState>(
                    listener: (context, state) {
                      if (state is RoomConnectionError) {
                        CommonWidgets.displaySnackBar(
                          context: context,
                          message: state.message,
                          color: CustomColors.snackBarError,
                          lightText: true,
                        );
                      } else if (state is RoomConnectionConnectedToRoom) {
                        Navigator.of(context).pushNamedAndRemoveUntil<void>(
                          PlanningScreen.routeName,
                          (route) => false,
                          arguments: state.roomName,
                        );
                      }
                    },
                    child: BlocBuilder<LobbyBloc, LobbyState>(
                      buildWhen: (_, state) {
                        if (state is LobbyStatusLoaded ||
                            state is LobbyLoading ||
                            state is LobbyLoadingError) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                      builder: (context, state) {
                        if (state is LobbyStatusLoaded) {
                          if (state.lobbyStatus.leftRoomReason.isNotEmpty) {
                            CommonWidgets.displaySnackBar(
                              context: context,
                              message:
                                  "Disconnected from room.\n Reason: ${state.lobbyStatus.leftRoomReason}",
                              color: CustomColors.snackBarInfo,
                            );
                          }
                          rooms = state.lobbyStatus.rooms;
                          return rooms.length > 0
                              ? RoomList(rooms: rooms)
                              : Center(
                                  child: Text(
                                    'There are no available rooms at the moment.\nWhy don\'t you create one?',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                        } else if (state is LobbyLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is LobbyLoadingError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            key: Key(Keys.buttonNavigateToCreateRoomScreen),
            backgroundColor: Colors.grey[200],
            elevation: 15,
            child: Text(
              '+',
              style:
                  TextStyle(fontSize: 35, color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CreateRoomScreen.routeName);
            },
          ),
        ),
        BlocBuilder<RoomConnectionBloc, RoomConnectionState>(
          builder: (context, state) {
            if (state is RoomConnectionConnecting) {
              return LoadingLayer();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}

class RoomList extends StatefulWidget {
  final List<RoomUI> rooms;

  const RoomList({
    @required this.rooms,
  });

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  Key expandedTileKey;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.rooms.length,
      itemBuilder: (ctx, int i) {
        return Card(
          child: CustomExpansionTile(
            key: widget.rooms[i].key,
            shouldCollapse: expandedTileKey != widget.rooms[i].key,
            title: Text(
              widget.rooms[i].name,
              style: TextStyle(color: Colors.white),
            ),
            childrenPadding: EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 1,
            ),
            onExpansionChanged: (value) {
              setState(() {
                if (value) {
                  expandedTileKey = widget.rooms[i].key;
                }
              });
            },
            children: [
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: JoinOptionsColumn(
                  roomName: widget.rooms[i].name,
                ),
              )
            ],
            maintainState: true,
          ),
        );
      },
    );
  }
}

class JoinOptionsColumn extends StatefulWidget {
  final String roomName;

  JoinOptionsColumn({@required this.roomName});

  @override
  _JoinOptionsColumnState createState() => _JoinOptionsColumnState();
}

class _JoinOptionsColumnState extends State<JoinOptionsColumn> {
  bool asSpectator = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Estimator'),
            Checkbox(
              value: !asSpectator,
              onChanged: (value) {
                if (asSpectator)
                  setState(() {
                    asSpectator = !asSpectator;
                  });
              },
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).buttonColor,
            ),
            Text('Spectator'),
            Checkbox(
              value: asSpectator,
              onChanged: (value) {
                if (!asSpectator)
                  setState(() {
                    asSpectator = !asSpectator;
                  });
              },
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              activeColor: Theme.of(context).buttonColor,
            ),
          ],
        ),
        FlatButton(
          onPressed: () {
            print(asSpectator);
            BlocProvider.of<RoomConnectionBloc>(context).add(
              RoomConnectionConnectToRoomE(widget.roomName, asSpectator),
            );
          },
          child: Text('Join'),
          color: Theme.of(context).buttonColor,
        )
      ],
    );
  }
}
