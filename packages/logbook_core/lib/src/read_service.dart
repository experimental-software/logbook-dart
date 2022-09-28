import 'dart:io';

import 'package:logbook_core/logbook_core.dart';

class ReadService {
  Future<String> readDescriptionLogOrNoteDescriptionFile(Directory dir) async {
    var files = dir.listSync();

    final timeAndSlugMatcher = RegExp(r'.*/\d{2}.\d{2}_(.*)');
    var timeAndSlugMatch = timeAndSlugMatcher.firstMatch(dir.path)!;
    var slug = timeAndSlugMatch.group(1)!;

    var result = 'not found';
    for (var file in files) {
      if (file.path.endsWith('$slug.md') || file.path.endsWith('index.md')) {
        var f = File(file.path);
        var s = f.readAsStringSync();
        s = s.replaceFirst(RegExp(r'^#.*'), '');
        s = s.trim();
        result = s;
        break;
      }
    }
    return result;
  }
}

Future<LogEntry> toMandatoryLogEntry(String path) async {
  var logEntry = await toLogEntry(path);
  return logEntry!;
}
