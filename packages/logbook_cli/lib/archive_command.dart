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

    var logEntryDirectory = '';
    if (results.rest.isNotEmpty) {
      logEntryDirectory = results.rest.first;
    } else {
      throw 'Missing log entry directory';
    }

    await systemService.archive(logEntryDirectory);
  }
}
