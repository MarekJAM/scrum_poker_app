import 'package:flutter/material.dart';

import '../../../utils/custom_colors.dart';
import '../../../ui/ui_models/ui_models.dart';
import '../../../utils/asset_paths.dart';

class EstimatorCard extends StatelessWidget {
  final EstimatorCardModelUI card;
  final String estimatedTask;

  const EstimatorCard({
    @required this.card,
    @required this.estimatedTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      shape: CircleBorder(
        side: card.isAdmin
            ? BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: card.isInRoom
            ? CustomColors.buttonLightGrey
            : CustomColors.buttonGrey,
        child: card.estimate == null
            ? card.isAdmin
                ? Image.asset(
                    AssetPaths.crownIcon,
                    height: 30,
                  )
                : estimatedTask.isEmpty
                    ? Image.asset(
                        AssetPaths.userIcon,
                        height: 25,
                      )
                    : Icon(
                        Icons.help_outline,
                        size: 30,
                      )
            : Text(
                card.estimate == null ? '' : '${card.estimate}',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
