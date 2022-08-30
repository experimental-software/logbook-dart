import 'package:args/command_runner.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

class OpenCommand extends Command {

  @override
  final name = 'open';

  @override
  final description = "Open the Logbook's GUI.";

  @override
  void run() async {
    var args = argResults ?? '';
    System.openApp(args.toString());
  }
}
