import 'package:flutter/material.dart';

class LoadingLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AbsorbPointer(
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 7,
            ),
          ),
        ),
      ),
    );
  }
}
