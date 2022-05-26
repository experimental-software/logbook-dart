import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:engineering_logbook/core/log_entry.dart';

Future<List<LogEntry>> search(Directory dir, String query) async {
  final result = <LogEntry>[];
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

    if (entity.path.endsWith('index.md') || entity.path.endsWith('$slug.md')) {
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
          if (isSearchResult(title, query)) {
            result.add(LogEntry(title: title, dateTime: dateTime));
          }
          break;
        }
      }
    }
  }
  result.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  return result;
}

bool isSearchResult(String text, String query) {
  if (query.trim() == '') {
    return true;
  }
  final normalizedText = text.toLowerCase();
  final normalizedQuery = query.toLowerCase();
  var words = normalizedQuery.split(" ");
  for (var word in words) {
    if (normalizedText.contains(word)) {
      return true;
    }
  }
  return false;
}
