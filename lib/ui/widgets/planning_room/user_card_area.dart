import 'package:flutter/material.dart';

import '../../../ui/ui_models/ui_models.dart';
import 'widgets.dart';

class UserCardArea extends StatelessWidget {
  final UserCardModelUI card;
  final Size size;
  final bool isSpectator;
  final String estimatedTask;

  const UserCardArea({
    @required this.card,
    @required this.size,
    this.isSpectator = false,
    this.estimatedTask = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 1 / 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isSpectator
                ? SpectatorCard(card: card)
                : EstimatorCard(
                    card: card,
                    estimatedTask: estimatedTask,
                  ),
          ),
          Text(
            card.username,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
