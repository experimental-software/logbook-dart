#!/usr/bin/env dart

import 'package:args/command_runner.dart';
import 'package:logbook_cli/search.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

void main(List<String> args) {
  GetIt.I.registerSingleton(SearchService());

  CommandRunner('logbook', 'A markdown-based engineering logbook.')
    ..addCommand(SearchCommand())
    ..run(args);
}
