import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';

class GridBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberColors.gridLine.withAlpha(8)
      ..strokeWidth = 0.5;
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final codePaint = Paint()
      ..color = CyberColors.dimCyan.withAlpha(6)
      ..strokeWidth = 1;
    for (double x = 5; x < size.width; x += spacing) {
      final len = (x * 7 + x * x) % 150 + 30;
      canvas.drawLine(Offset(x, 0), Offset(x, len), codePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BracketFrame extends StatelessWidget {
  final Widget child;
  final Color color;
  final double padding;

  const BracketFrame({
    super.key,
    required this.child,
    this.color = CyberColors.neonCyan,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BracketPainter(color: color),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final Color color;
  _BracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const bracket = 12.0;
    final h = size.height, w = size.width;
    // Top-left
    canvas.drawLine(Offset(0, bracket), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(bracket, 0), paint);
    // Top-right
    canvas.drawLine(Offset(w - bracket, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, bracket), paint);
    // Bottom-left
    canvas.drawLine(Offset(0, h - bracket), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(bracket, h), paint);
    // Bottom-right
    canvas.drawLine(Offset(w - bracket, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - bracket), paint);
  }

  @override
  bool shouldRepaint(covariant _BracketPainter old) => old.color != color;
}

class HexBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const HexBadge({
    super.key,
    required this.label,
    required this.value,
    this.color = CyberColors.neonCyan,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HexPainter(color: color),
      size: const Size(64, 72),
      child: SizedBox(
        width: 64,
        height: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: CyberColors.textDim)),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  final Color color;
  _HexPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(40)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height * 0.75)
      ..lineTo(0, size.height * 0.25)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _HexPainter old) => old.color != color;
}

class GlassmorphicCapsule extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const GlassmorphicCapsule({
    super.key,
    required this.icon,
    required this.text,
    this.color = CyberColors.amberGold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, color: color, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class TechButton extends StatelessWidget {
  final String text;
  final String subtext;
  final VoidCallback? onPressed;
  final Color color;

  const TechButton({
    super.key,
    required this.text,
    this.subtext = '',
    this.onPressed,
    this.color = CyberColors.neonCyan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('❮ ', style: TextStyle(color: color, fontSize: 16)),
            Column(
              children: [
                Text(text, style: TextStyle(color: color, fontSize: 14, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                if (subtext.isNotEmpty)
                  Text(subtext, style: TextStyle(color: color.withAlpha(180), fontSize: 10, fontFamily: 'monospace')),
              ],
            ),
            Text(' ❯', style: TextStyle(color: color, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        if (trailing != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: CyberColors.dimCyan, width: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(trailing!, style: const TextStyle(color: CyberColors.textDim, fontSize: 11, fontFamily: 'monospace')),
          ),
      ],
    );
  }
}

class SegmentedBar extends StatelessWidget {
  final double progress;
  final int segments;

  const SegmentedBar({super.key, required this.progress, this.segments = 10});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(segments, (i) {
        final filled = i / segments < progress;
        return Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: filled ? CyberColors.neonCyan : CyberColors.progressEmpty,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      }),
    );
  }
}
