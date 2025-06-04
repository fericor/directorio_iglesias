import 'dart:math';

import 'package:flutter/material.dart';

class Teatro2Screen extends StatelessWidget {
  const Teatro2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teatro CustomPaint")),
      body: CustomPaint(
        painter: Teatro2Painter(),
        child: Container(),
      ),
    );
  }
}

class Teatro2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Dibujar sillas en semicírculo
    final center = Offset(size.width / 2, size.height / 3);
    final radius = 150.0;

    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 3.14; // Ángulo para la silla
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), 20, i % 2 == 0 ? selectedPaint : paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
