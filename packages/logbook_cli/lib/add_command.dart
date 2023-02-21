import 'dart:io';

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
      'open',
      abbr: 'o',
      help: 'Open the log entry the configured text editor',
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

    if (results['open']) {
      var textEditor = LogbookConfig().textEditor;
      if (textEditor == null) {
        print('ERROR: No text editor specified in config file.');
        exit(1);
      }
      try {
        await System.openInTextEditor(textEditor, logEntry.directory);
      } catch (e) {
        print("ERROR: Failed to open log entry '${logEntry.directory}' "
            "with text editor '$textEditor'.");
        rethrow;
      }
    }
  }
}
