import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/bloc.dart';
import '../../../utils/keys.dart';
import '../../../utils/custom_colors.dart';

class ConfirmSendEstimateDialog extends StatelessWidget {
  const ConfirmSendEstimateDialog(this.estimatedTask, this.estimate);

  final String estimatedTask;
  final int estimate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
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
                RaisedButton(
                  key: Key(Keys.buttonSendEstimateConfirm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                RaisedButton(
                  color: CustomColors.buttonGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
    );
  }
}
