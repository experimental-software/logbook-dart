import 'dart:convert';
import 'dart:io';

class LogEntry {
  final DateTime dateTime;
  final String title;
  final String directory;

  LogEntry({
    required this.dateTime,
    required this.title,
    required this.directory,
  });
}

Future<LogEntry> open(Directory dir) async {
  Stream<FileSystemEntity> entityList = dir.list(recursive: true);
  await for (FileSystemEntity entity in entityList) {
    if (!entity.path.endsWith('.md')) {
      continue;
    }
    var parentDirectoryName = entity.parent.path;
    final timeAndSlugMatcher = RegExp(r'.*/\d{2}.\d{2}_(.*)');
    var timeAndSlugMatch = timeAndSlugMatcher.firstMatch(parentDirectoryName);
    if (timeAndSlugMatch == null) {
      continue;
    }
    var slug = timeAndSlugMatch.group(1)!;

    if (entity.path.endsWith('$slug.md')) {
      final file = File(entity.path);
      Stream<String> lines = file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      await for (var line in lines) {
        if (line.startsWith('# ')) {
          final regex = RegExp(r'.*(\d{4})/(\d{2})/(\d{2})/(\d{2})\.(\d{2}).*');
          final match = regex.firstMatch(entity.path);
          late DateTime dateTime;
          if (match != null) {
            final year = int.parse(match.group(1)!);
            final month = int.parse(match.group(2)!);
            final day = int.parse(match.group(3)!);
            final hour = int.parse(match.group(4)!);
            final minute = int.parse(match.group(5)!);
            dateTime = DateTime(year, month, day, hour, minute);
          } else {
            continue;
          }
          final title = line.substring(2);
          return LogEntry(
            title: title,
            dateTime: dateTime,
            directory: entity.parent.path,
          );
        }
        break;
      }
    }
  }
  throw 'Failed to find log entry in dir';
}

String encodePath(String path) {
  return base64.encode(utf8.encode(path));
}
