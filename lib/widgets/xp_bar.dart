import 'package:flutter/material.dart';

class XpBar extends StatelessWidget {
  final int current;
  final int max;
  final double height;
  final Color? color;

  const XpBar({
    super.key,
    required this.current,
    required this.max,
    this.height = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: Colors.grey.withAlpha(50),
        valueColor: AlwaysStoppedAnimation(color ?? Colors.blue),
      ),
    );
  }
}
