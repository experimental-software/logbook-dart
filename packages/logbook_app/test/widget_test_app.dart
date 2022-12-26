import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logbook_app/state.dart';

class WidgetTestApp extends StatelessWidget {
  final Widget widget;

  const WidgetTestApp(this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogbookBloc(),
      child: MaterialApp(
        home: widget,
      ),
    );
  }
}
