import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/planning_room_bloc.dart';
import '../../../configurable/keys.dart';
import '../../../configurable/custom_colors.dart';

class ConfirmSendEstimateDialog extends StatelessWidget {
  const ConfirmSendEstimateDialog(
      this.estimatedTask, this.estimate, this.mediaQuery);

  final String estimatedTask;
  final int estimate;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: mediaQuery.orientation == Orientation.portrait
            ? null
            : mediaQuery.size.width / 2,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(text: 'Do you want to estimate task '),
                      TextSpan(
                        text: '$estimatedTask ',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: 'to '),
                      TextSpan(
                        text: '$estimate',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: '?'),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    key: Key(Keys.buttonSendEstimateConfirm),
                    child: Text(
                      "Yes",
                    ),
                    onPressed: () {
                      BlocProvider.of<PlanningRoomBloc>(context).add(
                        PlanningRoomSendEstimateE(
                          estimate,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        CustomColors.buttonGrey,
                      ),
                    ),
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: CustomColors.textDark,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
