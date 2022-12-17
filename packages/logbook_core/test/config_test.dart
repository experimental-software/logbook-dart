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

  test('create file with default values', () {
    var config = LogbookConfig();

    var logDirectory = config.logDirectory;

    expect(
        logDirectory.path, equals('${home.path}${Platform.pathSeparator}Logs'));
  });

  test('use default values for invalid yaml syntax', () async {
    await createConfig('":::::": :::');
    var config = LogbookConfig();

    var logDirectory = config.logDirectory;

    expect(
        logDirectory.path, equals('${home.path}${Platform.pathSeparator}Logs'));
  });

  test('configure log write directory', () async {
    await createConfig(
        'logDirectory: ~${Platform.pathSeparator}doc${Platform.pathSeparator}Notizen');
    var config = LogbookConfig();

    var logDirectory = config.logDirectory;

    expect(
        logDirectory.path,
        equals(
            '${home.path}${Platform.pathSeparator}doc${Platform.pathSeparator}Notizen'));
  });

  test('configure log read directory', () async {
    await createConfig(
        'archiveDirectory: ~${Platform.pathSeparator}doc${Platform.pathSeparator}Archiv');
    var config = LogbookConfig();

    var archiveDirectory = config.archiveDirectory;

    expect(
        archiveDirectory.path,
        equals(
            '${home.path}${Platform.pathSeparator}doc${Platform.pathSeparator}Archiv'));
  });
}
