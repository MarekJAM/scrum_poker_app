import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircleEstimatesChart extends StatefulWidget {
  final int usersEstimatedNumber;
  final int usersTotalNumber;
  final double width;
  final double height;
  final TextStyle rateTextStyle;
  final Color progressColor;
  final Color backgroundColor;
  final List<Widget> children;

  CircleEstimatesChart({
    @required this.usersEstimatedNumber,
    @required this.usersTotalNumber,
    this.children,
    this.rateTextStyle,
    this.backgroundColor,
    this.progressColor,
    this.width = 128,
    this.height = 128,
  });

  @override
  State<StatefulWidget> createState() => CircleEstimatesChartState();
}

class CircleEstimatesChartState extends State<CircleEstimatesChart>
    with TickerProviderStateMixin {
  CirclePainter _painter;

  @override
  Widget build(BuildContext context) {
    _painter = CirclePainter(
      usersEstimatedNumber: widget.usersEstimatedNumber,
      usersTotalNumber: widget.usersTotalNumber,
      backgroundColor: widget.backgroundColor,
      progressColor: widget.progressColor,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: CustomPaint(painter: _painter),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color progressColor;
  final Color backgroundColor;
  final int usersEstimatedNumber;
  final int usersTotalNumber;
  Paint _paint;

  CirclePainter({
    @required this.usersEstimatedNumber,
    @required this.usersTotalNumber,
    this.backgroundColor,
    this.progressColor,
  }) {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    _paint.color = backgroundColor ?? Colors.black12;
    canvas.drawArc(Offset.zero & size, -math.pi * 1.5 + math.pi / 4,
        (3 * math.pi) / 2, false, _paint);

    _paint.color = progressColor ?? Colors.orange;

    if (usersEstimatedNumber > 0) {
      canvas.drawArc(
          Offset.zero & size,
          -math.pi * 1.5 + math.pi / 4,
          (3 * math.pi) * (usersEstimatedNumber / usersTotalNumber) / 2,
          false,
          _paint);
    }

    double progressRadians = ((usersEstimatedNumber /
            (usersTotalNumber > 0 ? usersTotalNumber : 1)) *
        (3 * math.pi / 2));
    double startAngle = (-math.pi * 1.5 + math.pi / 4) +
        (3 * math.pi) * (usersEstimatedNumber / usersTotalNumber) / 2;

    canvas.drawArc(
        Offset.zero & size, startAngle, -progressRadians, false, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}
