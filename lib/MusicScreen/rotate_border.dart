import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class RotatingBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final double size;

  const RotatingBorder({
    Key? key,
    required this.child,
    this.borderWidth = 2.0,
    this.size = 180.0, // Adjust the size to reduce height
  }) : super(key: key);

  @override
  _RotatingBorderState createState() => _RotatingBorderState();
}

class _RotatingBorderState extends State<RotatingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size-3,
          height: widget.size,
          padding: EdgeInsets.all(widget.borderWidth),
          decoration: BoxDecoration(
            // border: BoxBorder(10),
            shape: BoxShape.rectangle,
            gradient: SweepGradient(
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
                Colors.red,
              ],
              stops: const [0.0, 0.14, 0.28, 0.42, 0.57, 0.71, 0.85, 1.0],
              transform: GradientRotation(_controller.value * 2 * pi),
            ),
          ),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
