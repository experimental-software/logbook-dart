#!/usr/bin/env dart

import 'package:args/command_runner.dart';
import 'package:logbook_cli/search.dart';

void main(List<String> args) {
  CommandRunner('logbook', 'A markdown-based engineering logbook.')
    ..addCommand(SearchCommand())
    ..run(args);
}
