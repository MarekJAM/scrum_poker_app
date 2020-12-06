import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrum_poker_app/ui/ui_models/ui_models.dart';
import 'dart:math' as math;

import '../../../bloc/planning_room/planning_room_bloc.dart';

class ExampleModel {
  int value;
  double frequency;
  Color color;

  ExampleModel(this.value, this.frequency, this.color);
}

class EstimatesChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EstimatesChartState();
}

class EstimatesChartState extends State {
  List<ExampleModel> list = [
    // ExampleModel(1, 0, Colors.orange),
    // ExampleModel(1, 1, Colors.black),
    ExampleModel(2, 1, Colors.teal),
    ExampleModel(3, 3, Colors.purple),
    ExampleModel(4, 2, Colors.yellow),
    ExampleModel(5, 1, Colors.pink),
    ExampleModel(6, 2, Colors.orange),
    ExampleModel(7, 1, Colors.green[200]),
    ExampleModel(9, 1, Colors.red),
    // ExampleModel(2, 1, Colors.blue),
    // ExampleModel(2, 2, Colors.brown),
    // ExampleModel(3, 1, Colors.green)
  ];
  var chartProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanningRoomBloc, PlanningRoomState>(
      buildWhen: (_, state) {
        if (state is PlanningRoomRoomStatusLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is PlanningRoomRoomStatusLoaded) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 20,
                    sections: showingSections(),
                  ),
                ),
              ),
              Center(
                child: CircleChart(
                  usersEstimatedNumber: state.planningRoomStatusInfo.estimatedTaskInfo
                      .estimatesReceived,
                  usersTotalNumber: state.planningRoomStatusInfo.estimatedTaskInfo
                      .estimatesExpected,
                  width: 150,
                  height: 150,
                  progressColor: Theme.of(context).accentColor,
                  chartProgress: chartProgress,
                  // rateTextStyle: TextStyle(),
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return list
        .map((e) => PieChartSectionData(
              color: e.color,
              value: e.frequency,
              title: '${e.value}',
              radius: 40,
              titleStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ))
        .toList();
  }
}

class CircleChart extends StatefulWidget {
  final int usersEstimatedNumber;
  final int usersTotalNumber;
  final double width;
  final double height;
  final TextStyle rateTextStyle;
  final Duration animationDuration;
  final Color progressColor;
  final Color backgroundColor;
  final List<Widget> children;
  double chartProgress;

  CircleChart({
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
  });

  @override
  State<StatefulWidget> createState() => CircleChartState();
}

class CircleChartState extends State<CircleChart>
    with TickerProviderStateMixin {
  CirclePainter _painter;
  Animation<double> _animation;
  AnimationController _controller;

  initState() {
    super.initState();
    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
        });
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CircleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
          widget.chartProgress = _animation.value;
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
      chartProgress: widget.chartProgress,
      usersEstimatedNumber: widget.usersEstimatedNumber,
      usersTotalNumber: widget.usersTotalNumber,
      backgroundColor: widget.backgroundColor,
      progressColor: widget.progressColor,
    );
    // print(_controller);
    // print(_painter);
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

    if(usersEstimatedNumber > 0) {
      canvas.drawArc(Offset.zero & size, -math.pi * 1.5 + math.pi / 4,
        (3 * math.pi) * ((usersEstimatedNumber - 1 + chartProgress) / usersTotalNumber) / 2, false, _paint);
    }

    double progressRadians =
        ((usersEstimatedNumber / usersTotalNumber) * (3 * math.pi / 2) * (-animation.value));
    double startAngle = (-math.pi * 1.5 + math.pi / 4);

    canvas.drawArc(
        Offset.zero & size, startAngle, -progressRadians, false, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}
