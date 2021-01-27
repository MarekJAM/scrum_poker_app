import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:scrum_poker_app/ui/screens/screens.dart';
import 'package:scrum_poker_app/ui/ui_models/user_card.dart';
import 'dart:math' as math;

import '../../ui/widgets/app_drawer.dart';
import '../../ui/icons/custom_icons.dart';
import '../../ui/widgets/common/common_widgets.dart';
import '../widgets/planning_room/widgets.dart';
import '../../bloc/lobby/lobby_bloc.dart';
import '../../bloc/planning_room/planning_room_bloc.dart';
import '../../bloc/room_connection/room_connection_bloc.dart';
import 'lobby_screen.dart';
import '../../configurable/keys.dart';
import '../../configurable/custom_colors.dart';
import '../../utils/wakelock_wrapper.dart';
import '../../configurable/estimates.dart';

class PlanningScreen extends StatefulWidget {
  static const routeName = '/planning';

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen>
    with TickerProviderStateMixin {
  String taskId;

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
                  TaskInfoBar(
                    deviceSize: deviceSize,
                  ),
                  Divider(),
                  UserCardsContainer(deviceSize: deviceSize),
                ],
              ),
              BottomCardsBar(deviceSize: deviceSize)
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
}
