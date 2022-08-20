import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logbook/pages/details/contents.dart';
import 'package:logbook_core/logbook_core.dart';

import 'reload_bloc/reload_bloc.dart';

class DetailsPage extends StatelessWidget {
  final LogEntry logEntry;

  const DetailsPage({
    Key? key,
    required this.logEntry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReloadBloc(),
      child: DetailsPageContents(key: key, logEntry: logEntry),
    );
  }
}
