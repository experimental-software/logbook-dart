import 'dart:io';

import 'package:logbook_core/logbook_core.dart';
import 'package:logbook_core/src/config.dart';

Future<LogEntry> createExampleLogEntry({
  String title = 'Just a random test title',
}) async {
  LogbookConfig.homeDirectory = await Directory.systemTemp.createTemp();
  var writeService = WriteService();
  return writeService.createLogEntry(
    title: title,
    description: 'xxx',
  );
}
