import 'dart:io';

import 'package:logbook_core/src/writer.dart';
import 'package:test/test.dart';

void main() {
  group('slugify', () {
    test('create slug', () {
      var s = 'Hello, World!';

      var result = slugify(s);

      expect(result, equals('hello-world'));
    });
  });

  group('Create directory for log entry', () {
    test('create directory', () async {
      var baseDir = await Directory.systemTemp.createTemp();
      var time = DateTime(2022, 07, 07);

      var result = await WriterUtils.createLogEntryDirectory(
        baseDir,
        time,
        'just-a-test',
      );

      expect(result.existsSync(), equals(true));
    });

    test('prevent duplicate directory name', () async {
      var baseDir = await Directory.systemTemp.createTemp();
      var time = DateTime(2022, 07, 07);

      var firstDirectory = await WriterUtils.createLogEntryDirectory(
        baseDir,
        time,
        'just-a-test',
      );
      expect(firstDirectory.existsSync(), equals(true));

      var secondDirectory = await WriterUtils.createLogEntryDirectory(
        baseDir,
        time,
        'just-a-test',
      );
      expect(secondDirectory.existsSync(), equals(true));
      expect(
        secondDirectory.path.length,
        greaterThan(firstDirectory.path.length),
      );
    });
  });
}
