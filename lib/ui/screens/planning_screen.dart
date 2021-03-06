import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import '../../ui/screens/screens.dart';
import '../../ui/widgets/app_drawer.dart';
import '../../ui/icons/custom_icons.dart';
import '../../ui/widgets/common/common_widgets.dart';
import '../widgets/planning_room/widgets.dart';
import '../../bloc/lobby/lobby_bloc.dart';
import '../../bloc/planning_room/planning_room_bloc.dart';
import '../../bloc/room_connection/room_connection_bloc.dart';
import '../../configurable/keys.dart';
import '../../configurable/custom_colors.dart';
import '../../utils/wakelock_wrapper.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockWrapper.enable();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WakelockWrapper.disable();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final roomName = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildAdminAppBarAction(context, mediaQuery),
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
              Container(
                height: mediaQuery.size.height,
                child: mediaQuery.orientation == Orientation.portrait
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TaskInfoBar(
                            width: mediaQuery.size.width,
                          ),
                          Divider(),
                          UserCardsContainer(size: mediaQuery.size),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: TaskInfoBar(
                                width: mediaQuery.size.width / 2,
                              ),
                            ),
                            UserCardsContainer(size: mediaQuery.size / 2),
                          ],
                        ),
                      ),
              ),
              BottomCardsBar(
                mediaQuery: mediaQuery,
              )
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

  Widget _buildAdminAppBarAction(
      BuildContext context, MediaQueryData mediaQuery) {
    return BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
      buildWhen: (_, state) {
        return state is PlanningRoomRoomStatusLoaded;
      },
      builder: (context, state) {
        if (state is PlanningRoomRoomStatusLoaded &&
            state.planningRoomStatusInfo.amAdmin) {
          return IconButton(
            key: Key(Keys.buttonRequestEstimateOpenDialog),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            icon: Icon(
              CustomIcons.estimate_request,
            ),
            onPressed: () {
              _showRequestEstimateDialog(context, mediaQuery);
            },
          );
        }
        return Container();
      },
    );
  }

  void _showRequestEstimateDialog(
      BuildContext context, MediaQueryData mediaQuery) {
    TextEditingController _taskController = TextEditingController();
    final _reqestEstimateKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RequestEstimateDialog(
          reqestEstimateKey: _reqestEstimateKey,
          taskController: _taskController,
          mediaQuery: mediaQuery,
        );
      },
    );
  }
}
