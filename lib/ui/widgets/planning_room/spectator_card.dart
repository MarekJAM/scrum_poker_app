import 'package:flutter/material.dart';

import '../../../ui/ui_models/ui_models.dart';
import '../../../configurable/custom_colors.dart';
import '../../../configurable/asset_paths.dart';

class SpectatorCard extends StatelessWidget {
  final SpectatorCardModelUI card;

  const SpectatorCard({
    @required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      shape: CircleBorder(
        side: BorderSide(
          width: 2,
          color: Colors.lightBlue,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: CustomColors.buttonLightGrey,
        child: Image.asset(
          AssetPaths.binocularsIcon,
          height: 30,
        ),
      ),
    );
  }
}
