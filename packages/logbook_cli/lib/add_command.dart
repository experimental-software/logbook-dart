import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

class AddCommand extends Command {
  final WriteService writeService = GetIt.I.get();

  @override
  final name = 'add';

  @override
  final description = 'Adds new log entries.';

  AddCommand() {
    argParser.addFlag(
      'edit',
      abbr: 'e',
      help: 'Edit created log entry in external text editor.',
    );
  }

  @override
  void run() async {
    var results = argResults;
    if (results == null) {
      return;
    }

    var logEntryTitle = '';
    if (results.rest.isNotEmpty) {
      logEntryTitle = results.rest.first;
    } else {
      throw 'Missing log entry title';
    }

    var logEntry = await writeService.createLogEntry(title: logEntryTitle);
    print(logEntry.directory);

    if (results['edit']) {
      System.openInEditor(logEntry.directory);
    }
  }
}
