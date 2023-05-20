import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rainyroute/Utils/color_utils.dart';

class CustomProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final double radius;
  final Color color;

  const CustomProgressIndicator(
      {super.key,
      required this.strokeWidth,
      required this.radius,
      required this.color,
      required ImageProvider<Object> image});

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CustomProgressIndicatorPainter(
          animation: _animation,
          strokeWidth: widget.strokeWidth,
          color: widget.color,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CustomProgressIndicatorPainter extends CustomPainter {
  final Animation<double> animation;
  final double strokeWidth;
  final Color color;

  _CustomProgressIndicatorPainter(
      {required this.animation, required this.strokeWidth, required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = SweepGradient(
        colors: [
          hexStringToColor('#FF6053'),
          hexStringToColor('#393E5B'),
          hexStringToColor('#EDE6CB'),
        ],
        stops: const [
          0.0,
          0.5,
          1.0,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -pi / 2,
        pi * 2 * animation.value, false, paint);
  }

  @override
  bool shouldRepaint(_CustomProgressIndicatorPainter oldDelegate) {
    return true;
  }
}
