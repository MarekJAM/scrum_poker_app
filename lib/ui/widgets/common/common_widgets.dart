import 'package:flutter/material.dart';

class CommonWidgets {
  static void displaySnackBar({
    @required BuildContext context,
    @required String message,
    @required Color color,
    bool lightText = false,
  }) {
    return WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: color,
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: lightText ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
