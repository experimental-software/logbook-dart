import 'package:logbook/core/search.dart';
import 'package:logbook/util/system.dart';
import 'package:test/test.dart';

void main() {
  test('should find log entries', () async {
    var result = await search(System.baseDir, 'test');

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
}
