import 'dart:io';

import 'package:logbook/util/system.dart';
import 'package:uuid/uuid.dart';

import 'log_entry.dart';

Future<LogEntry> createLogEntry({
  required String title,
  required String description,
}) async {
  var now = DateTime.now();
  var baseDir = System.baseDir;
  var slug = slugify(title);

  var logEntryDirectory = await WriterUtils.createLogEntryDirectory(baseDir, now, slug);
  var logEntryPath = '${logEntryDirectory.path}/$slug.md';

  var logEntryFile = await File(logEntryPath).create();
  var sink = logEntryFile.openWrite();
  sink.write('# $title\n\n');
  sink.write(description);
  sink.write('\n');
  await sink.flush();
  await sink.close();

  return LogEntry(
    dateTime: now,
    title: title,
    directory: logEntryDirectory.path,
  );
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

class WriterUtils {
  static Future<Directory> createLogEntryDirectory(
      Directory baseDir,
      DateTime time,
      String slug,
      ) async {
    var year = time.year.toString();
    var month = time.month.toString().padLeft(2, '0');
    var day = time.day.toString().padLeft(2, '0');
    var hour = time.hour.toString().padLeft(2, '0');
    var minute = time.minute.toString().padLeft(2, '0');

    var logEntryDirectory =
        '${baseDir.path}/$year/$month/$day/$hour.${minute}_$slug';

    var result = Directory(logEntryDirectory);
    if (result.existsSync()) {
      logEntryDirectory += '_${const Uuid().v4()}';
      result = Directory(logEntryDirectory);
    }

    return result.create(recursive: true);
  }
}
