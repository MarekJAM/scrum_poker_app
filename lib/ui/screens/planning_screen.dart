import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math' as math;

import '../../ui/widgets/app_drawer.dart';
import '../../ui/icons/custom_icons.dart';
import '../../ui/widgets/common/common_widgets.dart';
import '../widgets/planning_room/widgets.dart';
import '../../bloc/lobby/lobby_bloc.dart';
import '../../bloc/planning_room/planning_room_bloc.dart';
import '../../bloc/room_connection/room_connection_bloc.dart';
import 'lobby_screen.dart';
import '../../utils/keys.dart';
import '../../utils/custom_colors.dart';
import '../../utils/notifier.dart';
import '../../utils/wakelock_wrapper.dart';

class PlanningScreen extends StatefulWidget {
  static const routeName = '/planning';

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen>
    with TickerProviderStateMixin {
  final double taskInfoBarHeight = 155;
  String taskId;
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
    20
  ];

  @override
  void initState() {
    super.initState();
    WakelockWrapper.enable();
  }

  @override
  void dispose() {
    super.dispose();
    WakelockWrapper.disable();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final roomName = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildAdminAppBarAction(context),
        ],
        title: Text(roomName),
      ),
      drawer: _buildAppDrawer(context),
      body: MultiBlocListener(
        listeners: [
          //handles navigating to lobby screen
          BlocListener<RoomConnectionBloc, RoomConnectionState>(
            listener: (context, state) {
              if (state is RoomConnectionDisconnectedFromRoom) {
                Navigator.of(context)
                    .pushReplacementNamed(LobbyScreen.routeName);
              } else if (state is RoomConnectionDisconnectingFromRoomError) {
                CommonWidgets.displaySnackBar(
                    context: context,
                    message: "Failed to disconnect from room.",
                    color: CustomColors.snackBarError,
                    lightText: true);
              } else if (state is RoomConnectionDestroyingRoomError) {
                CommonWidgets.displaySnackBar(
                    context: context,
                    message: "Failed to destroy room.",
                    color: CustomColors.snackBarError,
                    lightText: true);
              }
            },
          ),
          //handles situation when room gets disbanded
          BlocListener<LobbyBloc, LobbyState>(
            listener: (context, state) {
              if (state is LobbyStatusLoaded) {
                Navigator.of(context).pushAndRemoveUntil<void>(
                  LobbyScreen.route(),
                  (route) => false,
                );
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
                  color: CustomColors.snackBarError,
                  lightText: true);
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
  }

  void _leaveRoom(BuildContext context) {
    BlocProvider.of<RoomConnectionBloc>(context).add(
      RoomConnectionDisconnectFromRoomE(),
    );
  }

  Widget _buildAppDrawer(BuildContext context) {
    return AppDrawer(
      [
        ListTile(
          leading: Transform.rotate(
            child: Icon(Icons.save_alt),
            angle: 90 * math.pi / 180,
          ),
          title: Text('Leave room'),
          onTap: () {
            _leaveRoom(context);
          },
        ),
        BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
          buildWhen: (_, state) {
            return state is PlanningRoomRoomStatusLoaded;
          },
          builder: (context, state) {
            if (state is PlanningRoomRoomStatusLoaded &&
                state.planningRoomStatusInfo.amAdmin) {
              return ListTile(
                key: Key(Keys.buttonDestroyRoom),
                leading: Icon(
                  Icons.remove_circle,
                  color: Theme.of(context).errorColor,
                ),
                title: Text('Destroy room'),
                onTap: () {
                  _showDestroyRoomConfirmationDialog(context);
                },
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  void _showDestroyRoomConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDestroyRoomDialog();
      },
    );
  }

  Widget _buildAdminAppBarAction(BuildContext context) {
    return BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
      buildWhen: (_, state) {
        return state is PlanningRoomRoomStatusLoaded;
      },
      builder: (context, state) {
        if (state is PlanningRoomRoomStatusLoaded &&
            state.planningRoomStatusInfo.amAdmin) {
          return FlatButton(
            key: Key(Keys.buttonRequestEstimateOpenDialog),
            child: Icon(
              CustomIcons.estimate_request,
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
          return state is PlanningRoomRoomStatusLoaded;
        },
        builder: (_, state) {
          if (state is PlanningRoomRoomStatusLoaded) {
            return Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                for (var card
                    in state.planningRoomStatusInfo.userEstimationCards)
                  Container(
                    width: deviceSize.width * 1 / 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 8.0,
                            shape: CircleBorder(
                              side: card.isAdmin
                                  ? BorderSide(
                                      width: 2,
                                      color: Theme.of(context).accentColor,
                                    )
                                  : BorderSide.none,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: card.isInRoom
                                  ? CustomColors.buttonLightGrey
                                  : CustomColors.buttonGrey,
                              child: card.estimate == null
                                  ? Icon(Icons.help_outline)
                                  : Text(
                                      card.estimate == null
                                          ? ''
                                          : '${card.estimate}',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Text(
                          card.username,
                          textAlign: TextAlign.center,
                        )
                      ],
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
    return Positioned(
      bottom: 0,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 450),
        curve: Curves.linear,
        child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
          builder: (_, state) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: (state is PlanningRoomRoomStatusLoaded &&
                      !state.planningRoomStatusInfo.alreadyEstimated &&
                      state.planningRoomStatusInfo.estimatedTaskInfo.taskId
                          .isNotEmpty)
                  ? Container(
                      key: ValueKey(1),
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
                            _showEstimateConfirmationDialog(
                                context,
                                state.planningRoomStatusInfo.estimatedTaskInfo
                                    .taskId,
                                estimates[index]);
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
                    )
                  : Container(
                      key: ValueKey(2),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskInfoBar(BuildContext context, Size deviceSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Wrap(
          children: [
            Center(
              child: BlocConsumer<PlanningRoomBloc, PlanningRoomState>(
                listener: (_, state) {
                  if (state is PlanningRoomRoomStatusLoaded) {
                    if (state.planningRoomStatusInfo.estimatedTaskInfo.taskId !=
                            taskId &&
                        state.planningRoomStatusInfo.estimatedTaskInfo.taskId
                            .isNotEmpty &&
                        !state.planningRoomStatusInfo.amAdmin &&
                        taskId != null) {
                      Notifier.notify();
                    }
                  }
                },
                buildWhen: (_, state) {
                  return state is PlanningRoomRoomStatusLoaded;
                },
                builder: (_, state) {
                  if (state is PlanningRoomRoomStatusLoaded) {
                    taskId =
                        state.planningRoomStatusInfo.estimatedTaskInfo.taskId;
                    return taskId.isEmpty
                        ? Container(
                            height: taskInfoBarHeight,
                            child: Center(
                              child: Text(
                                "No estimation in progress.",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(
                            width: deviceSize.width,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                  ),
                                  Expanded(child: EstimatesChart()),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "${state.planningRoomStatusInfo.estimatedTaskInfo.taskId}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
                                        Text(
                                          "Median: ${state.planningRoomStatusInfo.estimatedTaskInfo.median ?? '-'}\nAverage: ${state.planningRoomStatusInfo.estimatedTaskInfo.average ?? '-'}",
                                          key: Key(Keys.textMedianAndAverage),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
        height: taskInfoBarHeight,
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

  void _showEstimateConfirmationDialog(
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
                state.planningRoomStatusInfo.estimatedTaskInfo.taskId !=
                    estimatedTask) {
              Navigator.of(context).pop();
            }
          },
          child: ConfirmSendEstimateDialog(estimatedTask, estimate),
        );
      },
    );
  }
}
