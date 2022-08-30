import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logbook_core/src/log_entry.dart';

class SearchService {
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

      if (entity.path.endsWith('$slug.md')) {
        final file = File(entity.path);
        Stream<String> lines = file
            .openRead()
            .transform(utf8.decoder)
            .transform(const LineSplitter());
        await for (var line in lines) {
          if (line.startsWith('# ')) {
            final regex =
                RegExp(r'.*(\d{4})/(\d{2})/(\d{2})/(\d{2})\.(\d{2}).*');
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
              result.add(LogEntry(
                title: title,
                dateTime: dateTime,
                directory: entity.parent.path,
              ));
            }
            break;
          }
        }
      }
    }
    result.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return result;
  }

  Future<List<Note>> listNotes(LogEntry logEntry) async {
    var result = <Note>[];

    var dir = Directory(logEntry.directory);
    Stream<FileSystemEntity> entityList = dir.list(recursive: true);
    await for (FileSystemEntity entity in entityList) {
      if (!entity.path.endsWith('index.md')) {
        continue;
      }

      var simpleNameMatch = RegExp(r'.*\/(.*?)$').firstMatch(
        entity.parent.path,
      );
      if (simpleNameMatch == null) {
        continue;
      }
      var simpleDirectoryName = simpleNameMatch.group(1)!;

      var noteIndexMatch = RegExp(r'(\d+)_.*').firstMatch(
        simpleDirectoryName,
      );
      if (noteIndexMatch == null) {
        continue;
      }
      var noteIndex = int.parse(noteIndexMatch.group(1)!);

      var noteTitle = await readNoteTitle(entity.path);
      if (noteTitle == null) {
        continue;
      }

      result.add(
        Note(
          index: noteIndex,
          title: noteTitle,
          directory: entity.parent.path,
        ),
      );
    }

    result.sort((a, b) => a.index.compareTo(b.index));
    return result;
  }
}

Future<LogEntry> toLogEntry(Directory logEntryDir) async {
  final timeAndSlugMatcher = RegExp(r'.*/\d{2}.\d{2}_(.*)');
  var timeAndSlugMatch = timeAndSlugMatcher.firstMatch(logEntryDir.path);
  if (timeAndSlugMatch == null) {
    throw 'Invalid log entry path';
  }
  var slug = timeAndSlugMatch.group(1)!;

  for (var f in logEntryDir.listSync()) {
    if (!f.path.endsWith('$slug.md')) {
      continue;
    }
    final file = File(f.path);
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (var line in lines) {
      if (line.startsWith('# ')) {
        final regex =
        RegExp(r'.*(\d{4})/(\d{2})/(\d{2})/(\d{2})\.(\d{2}).*');
        final match = regex.firstMatch(f.path);
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
          directory: logEntryDir.path,
        );
      }
    }
  }
  throw 'Failed to get log entry';
}

bool isSearchResult(String text, String query) {
  if (query.trim() == '') {
    return true;
  }
  final normalizedText = text.toLowerCase();
  final normalizedQuery = query.toLowerCase();
  var queryTokens = normalizedQuery.split(' ');
  for (var token in queryTokens) {
    if (!normalizedText.contains(token)) {
      return false;
    }
  }
  return true;
}

Future<String?> readNoteTitle(String markdownFilePath) async {
  String? result;

  final file = File(markdownFilePath);
  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(const LineSplitter());
  await for (var line in lines) {
    if (line.startsWith('# ')) {
      var titleMatch = RegExp(r'# (.*)').firstMatch(line);
      if (titleMatch == null) {
        continue;
      }
      result = titleMatch.group(1)!;
      break;
    }
  }

  return result;
}
