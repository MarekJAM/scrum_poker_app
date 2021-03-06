import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/planning_room/planning_room_bloc.dart';
import '../../../configurable/keys.dart';

class RequestEstimateDialog extends StatelessWidget {
  const RequestEstimateDialog({
    Key key,
    @required GlobalKey<FormState> reqestEstimateKey,
    @required TextEditingController taskController,
    @required MediaQueryData mediaQuery,
  })  : _reqestEstimateKey = reqestEstimateKey,
        _taskController = taskController,
        _mediaQuery = mediaQuery,
        super(key: key);

  final GlobalKey<FormState> _reqestEstimateKey;
  final TextEditingController _taskController;
  final MediaQueryData _mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: _mediaQuery.orientation == Orientation.portrait
            ? null
            : _mediaQuery.size.width / 2,
        child: SingleChildScrollView(
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
                        if (value.trim().isEmpty) {
                          return "Provide task id.";
                        } else if (value.trim().length > 10) {
                          return "Text too long - max. 10 characters.";
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    key: Key(Keys.buttonRequestEstimateConfirm),
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
        ),
      ),
    );
  }
}
