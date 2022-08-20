import 'dart:io';

import 'package:logbook_core/src/log_entry.dart';
import 'package:logbook_core/src/search_service.dart';
import 'package:logbook_core/src/system.dart';
import 'package:logbook_core/src/write_service.dart';
import 'package:test/test.dart';

void main() {
  test('should find log entries', () async {
    var searchService = SearchService();
    var result = await searchService.search(System.baseDir, 'test');

    for (var logEntry in result) {
      // ignore: avoid_print
      print('${logEntry.dateTime.toIso8601String()} - ${logEntry.title}');
    }

    expect(result, isNotEmpty);
  });

  group('match', () {
    test('true for empty query', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = '';
      expect(isSearchResult(s, q), equals(true));
    });

    test('true for de-facto empty query', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = ' ';
      expect(isSearchResult(s, q), equals(true));
    });

    test('false for unknown word', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'blue';
      expect(isSearchResult(s, q), equals(false));
    });

    test('false for non-alphabetic query', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = '*';
      expect(isSearchResult(s, q), equals(false));
    });

    test('true for known word', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'fox';
      expect(isSearchResult(s, q), equals(true));
    });

    test('true for known word in differing case', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'FOX';
      expect(isSearchResult(s, q), equals(true));
    });

    test('false for known and unknown word', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'cat fox';
      expect(isSearchResult(s, q), equals(false));
    });
  });

  group('notes', () {


    test('find notes in log entry', () async {
      var writeService = WriteService();
      var searchService = SearchService();

      System.baseDir = await Directory.systemTemp.createTemp();
      var logEntry = await writeService.createLogEntry(
        title: 'Example log entry',
      );
      await writeService.createNoteEntry(
        title: 'Example note',
        description: 'xxx',
        baseDir: Directory(logEntry.directory),
      );

      List<Note> notes = await searchService.listNotes(logEntry);

      expect(notes.length, equals(1));
    });
  });
}
