import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook/pages/details/index.dart';
import 'package:logbook_core/logbook_core.dart';

import 'pages/homepage/index.dart';

void main(List<String> args) async {
  GetIt.I.registerSingleton(SearchService());
  GetIt.I.registerSingleton(WriteService());
  GetIt.I.registerSingleton(SystemService());
  GetIt.I.registerSingleton(ReadService());

  LogEntry? logEntry;
  if (args.isNotEmpty) {
    logEntry = await toLogEntry(args.first);
  }

  runApp(LogbookApp(logEntry: logEntry));
}

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

const pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
    TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
  },
);

class LogbookApp extends StatelessWidget {
  final LogEntry? logEntry;

  const LogbookApp({Key? key, this.logEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget startPage;
    if (logEntry == null) {
      startPage = const Homepage();
    } else {
      startPage = DetailsPage(originalLogEntry: logEntry!);
    }
    return MaterialApp(
      home: startPage,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        pageTransitionsTheme: pageTransitionsTheme,
      ),
    );
  }
}
