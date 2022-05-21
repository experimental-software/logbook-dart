import 'dart:io';

import 'package:engineering_logbook/core/search.dart';
import 'package:test/test.dart';

void main() {
  test('should find log entries', () async {
    var result = await search(Directory('/Users/jmewes/doc/Notizen'), "*");

    for (var logEntry in result) {
      print('${logEntry.dateTime.toIso8601String()} - ${logEntry.title}');
    }

    //expect(results, isNotEmpty);
  });

  group('match', () {
    test('true for empty query', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = '';
      expect(match(s, q), equals(true));
    });

    test('true for de-facto empty query', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = ' ';
      expect(match(s, q), equals(true));
    });

    test('false for unknown word', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'blue';
      expect(match(s, q), equals(false));
    });

    test('true for known word', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'fox';
      expect(match(s, q), equals(true));
    });

    test('true for known word in differing case', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'FOX';
      expect(match(s, q), equals(true));
    });

    test('true for known and unknown word', () {
      const s = 'The brown fox jumps over the lazy dog.';
      const q = 'cat fox';
      expect(match(s, q), equals(true));
    });
  });
}
