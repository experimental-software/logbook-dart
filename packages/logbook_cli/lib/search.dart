import 'package:args/command_runner.dart';
import 'package:logbook_core/logbook_core.dart';

class SearchCommand extends Command {
  @override
  final name = 'search';

  @override
  final description = 'Searches for log entries.';

  @override
  void run() async {
    if (argResults != null) {
      var searchTerm = '';
      if (argResults!.rest.isNotEmpty) {
        searchTerm = argResults!.rest.first;
      }
      var logEntries = await search(System.baseDir, searchTerm);
      for (var logEntry in logEntries) {
        print(logEntry.directory);
      }
    }
  }
}
