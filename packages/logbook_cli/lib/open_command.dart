import 'package:args/command_runner.dart';
import 'package:logbook_core/logbook_core.dart';

class OpenCommand extends Command {
  @override
  final name = 'open';

  @override
  final description = "Open the Logbook's GUI.";

  @override
  void run() async {
    String? noteDirectory;
    if (argResults != null) {
      var args = argResults!;
      if (args.rest.isNotEmpty) {
        noteDirectory = args.rest.first;
      }
    }
    System.openInApp(noteDirectory);
  }
}
