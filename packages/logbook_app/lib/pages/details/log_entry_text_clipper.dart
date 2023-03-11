import 'package:flutter/material.dart';

class LogEntryClippedTextBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;

    var p = Path();
    p.moveTo(size.width, size.height - 72);
    p.lineTo(size.width - 30, size.height - 72);
    p.arcToPoint(Offset(size.width - 72, size.height - 30),
        clockwise: false, radius: const Radius.elliptical(40, 40));
    p.lineTo(size.width - 72, size.height);

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LogEntryTextClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var p = Path();

    p.moveTo(0, 0); // top left
    p.lineTo(size.width, 0); // top right

    p.lineTo(size.width, size.height - 72);
    p.lineTo(size.width - 72, size.height - 72);
    p.lineTo(size.width - 72, size.height);
    p.lineTo(0, size.height);

    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
