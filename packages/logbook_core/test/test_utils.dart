import 'dart:io';

import 'package:logbook_core/logbook_core.dart';

Future<LogEntry> createExampleLogEntry({
  String title = 'Just a random test title',
}) async {
  System.baseDir = await Directory.systemTemp.createTemp();
  var writeService = WriteService();
  return writeService.createLogEntry(
    title: title,
    description: 'xxx',
  );
}
