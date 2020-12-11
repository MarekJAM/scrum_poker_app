import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircleEstimatesChart extends StatefulWidget {
  final int usersEstimatedNumber;
  final int usersTotalNumber;
  final double width;
  final double height;
  final TextStyle rateTextStyle;
  final Duration animationDuration;
  final Color progressColor;
  final Color backgroundColor;
  final List<Widget> children;
  final String estimatedTaskId;
  final double chartProgress;

  CircleEstimatesChart({
    @required this.usersEstimatedNumber,
    @required this.usersTotalNumber,
    this.children,
    this.rateTextStyle,
    this.animationDuration = const Duration(seconds: 1),
    this.backgroundColor,
    this.progressColor,
    this.width = 128,
    this.height = 128,
    @required this.chartProgress,
    @required this.estimatedTaskId,
  });

  @override
  State<StatefulWidget> createState() => CircleEstimatesChartState();
}

class CircleEstimatesChartState extends State<CircleEstimatesChart>
    with TickerProviderStateMixin {
  CirclePainter _painter;
  Animation<double> _animation;
  AnimationController _controller;
  double _chartProgress;
  int countedEstimates = 0;
  String taskId;

  initState() {
    super.initState();

    _chartProgress = widget.chartProgress;

    taskId = widget.estimatedTaskId;

    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_animation.value == 1.0) {
            _chartProgress = _chartProgress.ceilToDouble();
          }
        });
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CircleEstimatesChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (taskId != widget.estimatedTaskId) {
      _chartProgress = 0.0;
      taskId = widget.estimatedTaskId;
    }

    //This condition is neccessary because technically animation is triggered even if nothing happens on the screen (so before anyone estimates)
    if (widget.usersEstimatedNumber > 1 &&
        countedEstimates != widget.usersEstimatedNumber) {
      _chartProgress += _animation.value;
    }

    countedEstimates = widget.usersEstimatedNumber;

    _controller.reset();
    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    _painter = CirclePainter(
      animation: _controller,
      chartProgress: _chartProgress,
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
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget child) {
                      return CustomPaint(painter: _painter);
                    },
                  ),
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
  final double chartProgress;
  final Animation<double> animation;
  Paint _paint;

  CirclePainter({
    @required this.usersEstimatedNumber,
    @required this.usersTotalNumber,
    @required this.chartProgress,
    @required this.animation,
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
          (3 * math.pi) * (chartProgress / usersTotalNumber) / 2,
          false,
          _paint);
    }

    double progressRadians =
        (((usersEstimatedNumber - chartProgress) / usersTotalNumber) *
            (3 * math.pi / 2) *
            (-animation.value));
    double startAngle = (-math.pi * 1.5 + math.pi / 4) +
        (3 * math.pi) * (chartProgress / usersTotalNumber) / 2;

    canvas.drawArc(
        Offset.zero & size, startAngle, -progressRadians, false, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}