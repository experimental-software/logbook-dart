import 'package:logbook/core/writer.dart';
import 'package:test/test.dart';

void main() {
  group('slugify', () {
    test('create slug', () {
      var s = 'Hello, World!';

      var result = slugify(s);

      expect(result, equals('hello-world'));
    });
  });
}
