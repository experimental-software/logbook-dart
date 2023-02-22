import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

class ArchiveCommand extends Command {
  final SystemService systemService = GetIt.I.get();

  @override
  final name = 'archive';

  @override
  final description = 'Moves log entries into the archive.';

  @override
  void run() async {
    var results = argResults;
    if (results == null) {
      return;
    }

    if (results.rest.isEmpty) {
      print('ERROR: No directory for archiving provided.');
      exit(1);
    }

    for (var dir in results.rest) {
      try {
        var archiveDir = await systemService.archive(dir);
        print(archiveDir);
      } catch (e) {
        print("ERROR: Failed to archive log entry '$dir'.");
        exit(1);
      }
    }
  }
}
