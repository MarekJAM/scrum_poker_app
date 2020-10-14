import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/bloc.dart';
import '../../../utils/keys.dart';

class RequestEstimateDialog extends StatelessWidget {
  const RequestEstimateDialog({
    Key key,
    @required GlobalKey<FormState> reqestEstimateKey,
    @required TextEditingController taskController,
  })  : _reqestEstimateKey = reqestEstimateKey,
        _taskController = taskController,
        super(key: key);

  final GlobalKey<FormState> _reqestEstimateKey;
  final TextEditingController _taskController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                  key: Key(Keys.inputEstimatedTask),
                  decoration: InputDecoration(labelText: "Task id"),
                  controller: _taskController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Provide task id.";
                    } else if (value.trim().length > 20) {
                      return "Text too long - max. 20 characters.";
                    }
                    return null;
                  },
                ),
              ),
              RaisedButton(
                key: Key(Keys.buttonRequestEstimateConfirm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Start estimation",
                ),
                onPressed: () {
                  if (_reqestEstimateKey.currentState.validate()) {
                    BlocProvider.of<PlanningRoomBloc>(context).add(
                      PlanningRoomSendEstimateRequestE(
                        _taskController.text.trim(),
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
  }
}
