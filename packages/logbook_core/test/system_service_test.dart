import 'dart:io';

import 'package:logbook_core/logbook_core.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('archive', () {
    test('archive via log directory path', () async {
      LogbookConfig.homeDirectory = await Directory.systemTemp.createTemp();
      var systemService = SystemService();
      var logEntry = await createExampleLogEntry(title: 'Example for test');

      await systemService.archive(logEntry.directory);

      expect(System.baseDir.listSync(), isEmpty);
      expect(System.archiveDir.listSync(), isNotEmpty);
    });

    test('archive via child path', () async {
      LogbookConfig.homeDirectory = await Directory.systemTemp.createTemp();
      var systemService = SystemService();
      var logEntry = await createExampleLogEntry(title: 'Example for test');

      await systemService.archive(logEntry.path);

      expect(System.baseDir.listSync(), isEmpty);
      expect(System.archiveDir.listSync(), isNotEmpty);
    });
  });
}
