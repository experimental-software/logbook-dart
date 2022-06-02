import 'package:flutter/material.dart';

import 'pages/homepage/index.dart';

void main() => runApp(const LogbookApp());

class LogbookApp extends StatelessWidget {
  const LogbookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
