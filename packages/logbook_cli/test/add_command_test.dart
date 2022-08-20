import 'package:args/command_runner.dart';
import 'package:logbook_cli/add_command.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:test/test.dart';
import 'package:get_it/get_it.dart';

import 'dart:io';

void main() {
  test('add new log entry', () async {
    GetIt.I.registerSingleton(WriteService());
    System.baseDir = await Directory.systemTemp.createTemp();

    List<String> args = ['add', 'Example log entry'];
    var runner = CommandRunner('logbook-test', 'Just a test run');
    runner.addCommand(AddCommand());
    await runner.run(args);

    var hasCreatedMarkdownFile = false;
    Stream<FileSystemEntity> files = System.baseDir.list(recursive: true);
    await for (FileSystemEntity entity in files) {
      if (entity.path.endsWith('.md')) {
        hasCreatedMarkdownFile = true;
        break;
      }
    }
    expect(hasCreatedMarkdownFile, isTrue);
  });
}
