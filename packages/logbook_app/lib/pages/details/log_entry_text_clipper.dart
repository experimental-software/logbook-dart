import 'package:flutter/material.dart';
import 'dart:math';

class LogEntryClippedTextBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black;

    var p = Path();
    p.moveTo(size.width, size.height - 70);
    p.lineTo(size.width - 30, size.height - 70);
    p.arcToPoint(Offset(size.width - 70, size.height - 30),
        clockwise: false,
        radius: const Radius.elliptical(40, 40)
    );
    p.lineTo(size.width - 70, size.height);

    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LogEntryTextClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var p = Path();

    double degToRad(num deg) => deg * (pi / 180.0);

    p.moveTo(0, 0); // top left
    p.lineTo(size.width, 0); // top right
    p.lineTo(size.width, size.height - 65); // bottom right

    p.moveTo(size.width - 65, size.height);
    p.arcTo(Rect.fromLTRB(size.width - 65, size.height - 65, 65, 65), degToRad(0), degToRad(90), true);

    p.moveTo(size.width - 65, size.height);
    p.lineTo(0, size.height); // bottom left
    p.lineTo(0, 0); // top left

    print(size.width);
    print(size.height);


    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
