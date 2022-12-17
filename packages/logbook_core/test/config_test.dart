import 'dart:io';

import 'package:logbook_core/src/config.dart';
import 'package:test/test.dart';

Directory get home => LogbookConfig.homeDirectory;

Future<void> createConfig(String config) async {
  var path = '${LogbookConfig.homeDirectory.path}'
      '${Platform.pathSeparator}'
      '.config'
      '${Platform.pathSeparator}'
      'logbook'
      '${Platform.pathSeparator}'
      'config.yaml';
  var file = File(path);
  await file.create(recursive: true);
  await file.writeAsString(config);
}

void main() {
  setUp(() async {
    LogbookConfig.homeDirectory = await Directory.systemTemp.createTemp();
  });

  test('use default values without config file', () {
    var config = LogbookConfig();

    expect(
      config.logDirectory.path,
      equals('${home.path}${Platform.pathSeparator}Logs'),
    );
    expect(
      config.archiveDirectory.path,
      equals('${home.path}${Platform.pathSeparator}Archive'),
    );
  });

  test('use default values for invalid yaml syntax', () async {
    await createConfig('":::::": :::');
    var config = LogbookConfig();

    expect(
      config.logDirectory.path,
      equals('${home.path}${Platform.pathSeparator}Logs'),
    );
    expect(
      config.archiveDirectory.path,
      equals('${home.path}${Platform.pathSeparator}Archive'),
    );
  });

  group('use default values for partical config', () {
    test('default value for log directory', () async {
      await createConfig(
        'archiveDirectory: ~${Platform.pathSeparator}doc${Platform.pathSeparator}Archiv',
      );
      var config = LogbookConfig();

      var logDirectory = config.logDirectory;

      expect(logDirectory.path,
          equals('${home.path}${Platform.pathSeparator}Logs'));
    });

    test('default value for archive directory', () async {
      await createConfig(
        'logDirectory: ~${Platform.pathSeparator}doc${Platform.pathSeparator}Notizen',
      );
      var config = LogbookConfig();

      var archiveDirectory = config.archiveDirectory;

      expect(archiveDirectory.path,
          equals('${home.path}${Platform.pathSeparator}Archive'));
    });
  });

  test('configure log write directory', () async {
    await createConfig(
      'logDirectory: ~${Platform.pathSeparator}doc${Platform.pathSeparator}Notizen',
    );
    var config = LogbookConfig();

    var logDirectory = config.logDirectory;

    expect(
      logDirectory.path,
      equals('${home.path}'
          '${Platform.pathSeparator}'
          'doc'
          '${Platform.pathSeparator}'
          'Notizen'),
    );
  });

  test('configure log read directory', () async {
    await createConfig(
      'archiveDirectory: ~${Platform.pathSeparator}doc${Platform.pathSeparator}Archiv',
    );
    var config = LogbookConfig();

    var archiveDirectory = config.archiveDirectory;

    expect(
      archiveDirectory.path,
      equals('${home.path}'
          '${Platform.pathSeparator}'
          'doc'
          '${Platform.pathSeparator}'
          'Archiv'),
    );
  });
}
