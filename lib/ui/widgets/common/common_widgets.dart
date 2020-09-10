import 'package:flutter/material.dart';

class CommonWidgets {
  static void displaySnackBar({@required BuildContext context, @required String message, @required Color color, Color textColor}) {
    return WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: color,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor ?? textColor),
            ),
          ),
        );
      },
    );
  }
}