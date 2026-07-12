import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/watch_theme.dart';

/// CustomPainter que dibuja el mapa del recinto con zonas, caminos y marcadores
class MapPainter extends CustomPainter {
  final Animation<double> pulseAnim;

  MapPainter({required this.pulseAnim}) : super(repaint: pulseAnim);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background grid — light style
    final gridPaint = Paint()
      ..color = const Color(0xFFCDD8E8)
      ..strokeWidth = 0.5;
    for (double x = 0; x < w; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Zone definitions [Rect, Color, Label]
    final zones = [
      (
        Rect.fromLTWH(w * 0.3, h * 0.05, w * 0.4, h * 0.2),
        const Color(0xFF6B45F0),
        'Escenario\nPrincipal'
      ),
      (
        Rect.fromLTWH(w * 0.05, h * 0.05, w * 0.2, h * 0.35),
        const Color(0xFF00A882),
        'Zona A'
      ),
      (
        Rect.fromLTWH(w * 0.75, h * 0.05, w * 0.2, h * 0.25),
        const Color(0xFF1565C0),
        'Servicios'
      ),
      (
        Rect.fromLTWH(w * 0.05, h * 0.45, w * 0.35, h * 0.3),
        const Color(0xFFFF8F00),
        'Zona C'
      ),
      (
        Rect.fromLTWH(w * 0.45, h * 0.35, w * 0.25, h * 0.3),
        const Color(0xFF2E7D32),
        'Jardín\nCentral'
      ),
      (
        Rect.fromLTWH(w * 0.3, h * 0.75, w * 0.4, h * 0.18),
        const Color(0xFF795548),
        'Entrada'
      ),
    ];

    for (final zone in zones) {
      final (rect, color, label) = zone;
      final fillPaint = Paint()..color = color.withValues(alpha: 0.18);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        fillPaint,
      );
      final borderPaint = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        borderPaint,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: color,
            fontSize: 7,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: rect.width - 4);
      tp.paint(
        canvas,
        Offset(
          rect.center.dx - tp.width / 2,
          rect.center.dy - tp.height / 2,
        ),
      );
    }

    // Roads
    final roadPaint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.5, h * 0.25),
      Offset(w * 0.5, h * 0.75),
      roadPaint,
    );
    canvas.drawLine(
      Offset(w * 0.05, h * 0.42),
      Offset(w * 0.95, h * 0.42),
      roadPaint,
    );

    // Destination marker (Zona C)
    final destCenter = Offset(w * 0.225, h * 0.58);
    final pulsePaint = Paint()
      ..color = WatchColors.warning
          .withValues(alpha: 0.35 * (1 - (pulseAnim.value - 0.6) / 0.6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(destCenter, 14 * pulseAnim.value, pulsePaint);
    canvas.drawCircle(destCenter, 8, Paint()..color = WatchColors.warning);
    canvas.drawCircle(destCenter, 3, Paint()..color = Colors.white);

    // Current location marker
    final myLocCenter = Offset(w * 0.6, h * 0.58);
    canvas.drawCircle(myLocCenter, 6, Paint()..color = WatchColors.secondary);
    canvas.drawCircle(myLocCenter, 3, Paint()..color = Colors.white);
    final arrowPaint = Paint()
      ..color = WatchColors.secondary
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.save();
    canvas.translate(myLocCenter.dx, myLocCenter.dy);
    canvas.rotate(-math.pi / 4);
    canvas.drawLine(const Offset(0, 0), const Offset(0, -10), arrowPaint);
    canvas.drawLine(const Offset(0, -10), const Offset(-4, -6), arrowPaint);
    canvas.drawLine(const Offset(0, -10), const Offset(4, -6), arrowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapPainter old) => true;
}
