import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/ui/icons/custom_icons.dart';
import 'package:scrum_poker_app/ui/widgets/common/common_widgets.dart';
import '../widgets/planning_room/widgets.dart';
import '../../bloc/lobby/bloc.dart';
import '../../bloc/planning_room/bloc.dart';
import '../../data/repositories/repositories.dart';
import '../../bloc/room_connection/bloc.dart';
import 'lobby_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                  color: Theme.of(context).canvasColor,
                ),
                onPressed: () {
                  _leaveRoom(context);
                },
              ),
              actions: [
                _buildAdminAppBarAction(context),
              ],
              title: Text(roomName),
            ),
            body: MultiBlocListener(
              listeners: [
                //handles navigating to lobby screen
                BlocListener<RoomConnectionBloc, RoomConnectionState>(
                  listener: (context, state) {
                    if (state is RoomConnectionDisconnectedFromRoom) {
                      Navigator.of(context)
                          .pushReplacementNamed(LobbyScreen.routeName);
                    } else if (state
                        is RoomConnectionDisconnectingFromRoomError) {
                      CommonWidgets.displaySnackBar(
                        context: context,
                        message: "Failed to disconnect from room.",
                        color: Theme.of(context).errorColor,
                      );
                    }
                  },
                ),
                //handles situation when room gets disbanded
                BlocListener<LobbyBloc, LobbyState>(
                  listener: (context, state) {
                    if (state is LobbyStatusLoaded) {
                      Navigator.of(context)
                          .pushReplacementNamed(LobbyScreen.routeName);
                    }
                  },
                ),
              ],
              child: BlocListener<PlanningRoomBloc, PlanningRoomState>(
                listener: (context, state) {
                  if (state is PlanningRoomError) {
                    CommonWidgets.displaySnackBar(
                      context: context,
                      message: state.message,
                      color: Theme.of(context).errorColor,
                    );
                  }
                },
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTaskInfoBar(context, deviceSize),
                        Divider(),
                        _buildUserEstimationCards(context, deviceSize),
                      ],
                    ),
                    _buildBottomCardsBar(context, deviceSize, estimates)
                  ],
                ),
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

  Widget _buildAdminAppBarAction(BuildContext context) {
    return BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
      buildWhen: (_, state) {
        return state is PlanningRoomRoomStatusLoaded ? true : false;
      },
      builder: (context, state) {
        if (state is PlanningRoomRoomStatusLoaded && state.amAdmin) {
          return FlatButton(
            child: Icon(
              CustomIcons.estimate_request,
              color: Theme.of(context).canvasColor,
            ),
            onPressed: () {
              _showRequestEstimateDialog(context);
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildUserEstimationCards(BuildContext context, Size deviceSize) {
    return Container(
      width: double.infinity,
      child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
        buildWhen: (_, state) {
          return state is PlanningRoomRoomStatusLoaded ? true : false;
        },
        builder: (_, state) {
          if (state is PlanningRoomRoomStatusLoaded) {
            return Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                for (var card in state.userEstimationCards)
                  Container(
                    width: deviceSize.width * 1 / 3,
                    child: Card(
                      child: ListTile(
                        title: Text(card.username),
                        trailing: Text(
                            card.estimate == null ? '' : '${card.estimate}'),
                      ),
                    ),
                  ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildBottomCardsBar(
    BuildContext context,
    Size deviceSize,
    List<int> estimates,
  ) {
    return BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
      builder: (_, state) {
        if (state is PlanningRoomRoomStatusLoaded &&
            !state.alreadyEstimated &&
            state.roomStatus.taskId.isNotEmpty) {
          return Positioned(
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
                    _showConfirmationDialog(
                        context, state.roomStatus.taskId, estimates[index]);
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      child: Center(
                        child: AutoSizeText(
                          '${estimates[index]}',
                          minFontSize: 24,
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
          );
        }
        return Container();
      },
    );
  }

  Widget _buildTaskInfoBar(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Center(
          child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
            buildWhen: (_, state) {
              return state is PlanningRoomRoomStatusLoaded ? true : false;
            },
            builder: (_, state) {
              if (state is PlanningRoomRoomStatusLoaded) {
                return Text(
                  'Task: ${state.roomStatus.taskId}',
                  style: TextStyle(fontSize: 20),
                );
              }
              return Container();
            },
          ),
        ),
        height: deviceSize.height * 0.1,
      ),
    );
  }

  void _showRequestEstimateDialog(BuildContext context) {
    TextEditingController _taskController = TextEditingController();
    final _reqestEstimateKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RequestEstimateDialog(
          reqestEstimateKey: _reqestEstimateKey,
          taskController: _taskController,
        );
      },
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String estimatedTask,
    int estimate,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<PlanningRoomBloc, PlanningRoomState>(
          listener: (context, state) {
            if (state is PlanningRoomRoomStatusLoaded &&
                state.roomStatus.taskId != estimatedTask) {
              Navigator.of(context).pop();
            }
          },
          child: ConfirmSendEstimateDialog(estimatedTask, estimate),
        );
      },
    );
  }
}
