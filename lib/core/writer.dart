import 'dart:io';

import 'package:logbook/util/system.dart';

import 'log_entry.dart';

Future<LogEntry> createLogEntry({
  required String title,
  required String description,
}) async {
  var now = DateTime.now();
  var baseDir = System.baseDir;
  var slug = slugify(title);

  var year = now.year.toString();
  var month = now.month.toString().padLeft(2, '0');
  var day = now.day.toString().padLeft(2, '0');
  var hour = now.hour.toString().padLeft(2, '0');
  var minute = now.minute.toString().padLeft(2, '0');

  var logEntryDirectory =
      '${baseDir.path}/$year/$month/$day/$hour.${minute}_$slug';
  var logEntryPath = '$logEntryDirectory/$slug.md';

  var logEntryFile = await File(logEntryPath).create(recursive: true);
  var sink = logEntryFile.openWrite();
  sink.write('# $title\n\n');
  sink.write(description);
  sink.write('\n');
  await sink.flush();
  await sink.close();

  return LogEntry(dateTime: now, title: title, directory: logEntryDirectory);
}

Future<Directory> createNoteEntry({
  required String title,
  required String description,
  required Directory baseDir,
  required bool shouldGenerateId,
}) async {
  var slug = slugify(title);

  int numberOfDirectoriesInParent = 0;
  final Directory parentDirectory = Directory(baseDir.path);
  for (var f in parentDirectory.listSync()) {
    var name = f.path.split('/').last;
    if (!name.contains('.')) {
      numberOfDirectoriesInParent++;
    }
  }

  late String noteEntryDirectory;
  if (shouldGenerateId) {
    var id = (numberOfDirectoriesInParent + 1).toString().padLeft(2, '0');
    noteEntryDirectory = '${baseDir.path}/${id}0_$slug';
  } else {
    noteEntryDirectory = '${baseDir.path}/$slug';
  }

  var logEntryPath = '$noteEntryDirectory/index.md';

  var logEntryFile = await File(logEntryPath).create(recursive: true);
  var sink = logEntryFile.openWrite();
  sink.write('# $title\n\n');
  sink.write(description);
  sink.write('\n');
  await sink.flush();
  await sink.close();

  return Directory(noteEntryDirectory);
}

String slugify(String s) {
  var result = s.toLowerCase();
  result = result.replaceAll(RegExp(r'[^\w\s-]'), '');
  result = result.replaceAll(RegExp(r'[-\s]+'), '-');
  return result;
}
