import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton(
    this.title, {
    required this.onPressed,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textWidget = Padding(
      padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
      child: Text(title),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon!, size: 22),
        label: textWidget,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        child: textWidget,
      );
    }
  }
}
