import 'dart:io';

import 'package:logbook_core/logbook_core.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

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

  group('parseIndexFromDirectory', () {
    test('return value', () {
      var name = '005_example-dir';
      var result = WriterUtils.parseIndexFromDirectory(name);
      expect(result, equals(5));
    });

    test('return null', () {
      var name = 'example-dir';
      var result = WriterUtils.parseIndexFromDirectory(name);
      expect(result, isNull);
    });
  });

  group('updateLogEntry', () {
    test('should write new text and description', () async {
      final originalLogEntry = await createExampleLogEntry();

      var writeService = WriteService();
      await writeService.updateLogEntry(
        logEntry: originalLogEntry,
        title: 'New title',
        description: 'New description',
      );

      final updatedLogEntry = await toLogEntry(originalLogEntry.directory);
      expect(updatedLogEntry!.title, equals('New title'));

      var readService = ReadService();
      var description =
          await readService.readDescriptionLogOrNoteDescriptionFile(
        Directory(originalLogEntry.directory),
      );
      expect(description, contains('New description'));
    });
  });
}
