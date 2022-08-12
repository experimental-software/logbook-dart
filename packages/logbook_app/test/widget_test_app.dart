import 'package:flutter/material.dart';

class WidgetTestApp extends StatelessWidget {
  final Widget widget;

  const WidgetTestApp(this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: widget,
    );
  }
}
