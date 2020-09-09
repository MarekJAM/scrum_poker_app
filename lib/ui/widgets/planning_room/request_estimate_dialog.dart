import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/planning_room/bloc.dart';

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
                  decoration: InputDecoration(labelText: "Task number"),
                  controller: _taskController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Provide task number.";
                    }
                    return null;
                  },
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Send request",
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
                onPressed: () {
                  if (_reqestEstimateKey.currentState.validate()) {
                    BlocProvider.of<PlanningRoomBloc>(context).add(
                      PlanningRoomSendEstimateRequestE(
                        _taskController.text,
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
