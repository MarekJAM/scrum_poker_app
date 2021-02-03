import 'package:flutter/material.dart';

import '../../../configurable/custom_colors.dart';
import '../../../ui/ui_models/ui_models.dart';
import '../../../configurable/asset_paths.dart';
import '../../../configurable/estimates.dart';

class EstimatorCard extends StatefulWidget {
  final EstimatorCardModelUI card;
  final String estimatedTask;

  const EstimatorCard({
    @required this.card,
    @required this.estimatedTask,
  });

  @override
  _EstimatorCardState createState() => _EstimatorCardState();
}

class _EstimatorCardState extends State<EstimatorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      shape: CircleBorder(
        side: widget.card.isAdmin
            ? BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
              )
            : BorderSide(
                width: 2,
                color: Colors.blueGrey,
              ),
      ),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: widget.card.isInRoom
            ? CustomColors.buttonLightGrey
            : CustomColors.buttonGrey,
        child: Stack(
          children: [
            if (widget.card?.estimate != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Estimates.values
                        .firstWhere((el) => el.value == widget.card.estimate)
                        .color,
                  ),
                ),
              ),
            Center(
              child: widget.card.estimate == null
                  ? widget.card.isAdmin
                      ? Image.asset(
                          AssetPaths.crownIcon,
                          height: 30,
                          color: widget.card.alreadyEstimated
                              ? Theme.of(context).accentColor
                              : Theme.of(context).canvasColor,
                        )
                      : widget.estimatedTask.isEmpty
                          ? Image.asset(
                              AssetPaths.userIcon,
                              height: 25,
                            )
                          : Icon(
                              Icons.help_outline,
                              size: 30,
                              color: widget.card.alreadyEstimated
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).canvasColor,
                            )
                  : Text(
                      widget.card.estimate == null
                          ? ''
                          : '${widget.card.estimate}',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 45);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 35);

    path.quadraticBezierTo(size.width * 3 / 4, 47, size.width / 2, 40);
    path.quadraticBezierTo(size.width / 4, 33, 0, 40);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
