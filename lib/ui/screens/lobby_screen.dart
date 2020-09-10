import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/data/repositories/rooms_repository.dart';
import '../../bloc/lobby/bloc.dart';
import '../widgets/app_drawer.dart';
import '../../bloc/room_connection/bloc.dart';
import 'screens.dart';
import '../../ui/widgets/common/widgets.dart';

class LobbyScreen extends StatelessWidget {
  static const routeName = '/rooms';
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyScreen());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    List<String> rooms = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
      ),
      drawer: AppDrawer(),
      body: BlocProvider(
        create: (BuildContext context) => RoomConnectionBloc(
            roomsRepository: RepositoryProvider.of<RoomsRepository>(context)),
        child: Builder(builder: (context) {
          return Container(
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
                          color: Theme.of(context).errorColor,
                        );
                      } else if (state is RoomConnectionConnectedToRoom) {
                        Navigator.of(context).pushReplacementNamed(
                            PlanningScreen.routeName,
                            arguments: state.roomName);
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
                              message: "Disconnected from room.\n Reason: ${state.lobbyStatus.leftRoomReason}",
                              color: Colors.orange[400],
                              textColor: Colors.black
                            );
                          }
                          rooms = state.lobbyStatus.rooms;
                          return rooms.length > 0
                              ? ListView.builder(
                                  itemCount: rooms.length,
                                  itemBuilder: (ctx, int i) => Card(
                                    child: ListTile(
                                      title: Text(rooms[i]),
                                      onTap: () {
                                        BlocProvider.of<RoomConnectionBloc>(
                                                context)
                                            .add(
                                          RoomConnectionConnectToRoomE(
                                            rooms[i],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
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
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 35),
        ),
        onPressed: () {
          Navigator.of(context)
              .pushReplacementNamed(CreateRoomScreen.routeName);
        },
      ),
    );
  }

}
