import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/planning_room_bloc.dart';
import 'widgets.dart';

class UserCardsContainer extends StatelessWidget {
  final Size size;

  UserCardsContainer({@required this.size});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        child: BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
          buildWhen: (_, state) {
            return state is PlanningRoomRoomStatusLoaded;
          },
          builder: (_, state) {
            if (state is PlanningRoomRoomStatusLoaded) {
              return Container(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    for (var estimatorCard
                        in state.planningRoomStatusInfo.estimatorCards)
                      UserCardArea(
                        card: estimatorCard,
                        size: size,
                        estimatedTask: state
                            .planningRoomStatusInfo.estimatedTaskInfo.taskId,
                      ),
                    for (var spectatorCard
                        in state.planningRoomStatusInfo.spectatorCards)
                      UserCardArea(
                        card: spectatorCard,
                        size: size,
                        isSpectator: true,
                      )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
