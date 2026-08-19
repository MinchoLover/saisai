import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MockMap extends StatelessWidget {
  const MockMap({
    super.key,
    this.startLabel = '서울역',
    this.destinationLabel = '광화문',
    this.showRoute = true,
    this.showCandidates = false,
  });

  final String startLabel;
  final String destinationLabel;
  final bool showRoute;
  final bool showCandidates;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFFEAF0ED),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _StreetPainter(showRoute: showRoute)),
            if (showRoute) ...[
              Positioned(
                  left: 26,
                  bottom: 74,
                  child: _MapPin(label: startLabel, isStart: true)),
              Positioned(
                  right: 22, top: 54, child: _MapPin(label: destinationLabel)),
            ],
            if (showCandidates) ...const [
              Positioned(left: 76, top: 124, child: _PlaceMarker(emoji: '🌿')),
              Positioned(right: 70, top: 174, child: _PlaceMarker(emoji: '🏯')),
              Positioned(
                  left: 146, bottom: 112, child: _PlaceMarker(emoji: '🥟')),
            ],
            Positioned(
              right: 16,
              bottom: 24,
              child: Column(
                children: [
                  _MapAction(icon: Icons.my_location_rounded, onTap: () {}),
                  const SizedBox(height: 8),
                  _MapAction(icon: Icons.layers_outlined, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      );
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label, this.isStart = false});
  final String label;
  final bool isStart;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 12,
                    offset: Offset(0, 4))
              ],
            ),
            child: Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 3),
          Icon(isStart ? Icons.trip_origin_rounded : Icons.location_on_rounded,
              color: isStart ? AppTheme.ink : AppTheme.primary, size: 30),
        ],
      );
}

class _PlaceMarker extends StatelessWidget {
  const _PlaceMarker({required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.primary, width: 2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x26000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      );
}

class _MapAction extends StatelessWidget {
  const _MapAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: IconButton(onPressed: onTap, icon: Icon(icon), iconSize: 21),
      );
}

class _StreetPainter extends CustomPainter {
  const _StreetPainter({required this.showRoute});
  final bool showRoute;

  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = Colors.white.withValues(alpha: .86)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    final major = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    final park = Paint()..color = const Color(0xFFD7E8DC);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .08, size.height * .16, size.width * .26,
            size.height * .22),
        const Radius.circular(28),
      ),
      park,
    );
    for (var i = -1; i < 8; i++) {
      final y = size.height * (i * .17 + .08);
      final path = Path()
        ..moveTo(-20, y)
        ..quadraticBezierTo(size.width * .42, y + 34, size.width + 20, y - 8);
      canvas.drawPath(path, i == 2 ? major : minor);
    }
    for (var i = 0; i < 6; i++) {
      final x = size.width * (i * .21 + .03);
      final path = Path()
        ..moveTo(x, -20)
        ..quadraticBezierTo(x + 38, size.height * .52, x - 8, size.height + 20);
      canvas.drawPath(path, i == 3 ? major : minor);
    }
    if (showRoute) {
      final route = Paint()
        ..color = AppTheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      final routePath = Path()
        ..moveTo(size.width * .18, size.height * .78)
        ..cubicTo(size.width * .2, size.height * .52, size.width * .76,
            size.height * .68, size.width * .76, size.height * .25);
      canvas.drawPath(routePath, route);
      for (var t = 0.1; t < .95; t += .16) {
        final x = size.width * (.18 + .58 * t);
        final y =
            size.height * (.78 - .53 * t + math.sin(t * math.pi * 2) * .05);
        canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StreetPainter oldDelegate) =>
      oldDelegate.showRoute != showRoute;
}
