import 'dart:io';

import 'package:logbook_core/src/config.dart';
import 'package:path/path.dart' as path;
import 'package:system/system.dart' as sys;

class SystemService {
  Future<void> archive(String originalDirectoryPath) async {
    await System.archive(originalDirectoryPath);
  }

  void shutdownApp() {
    exit(0);
  }
}

class System {
  System._();

  static String get macVsCodePath =>
      '/Applications/Visual\\ Studio\\ Code.app/Contents/MacOS/Electron';

  static Future<void> openDirectory(String directory) async {
    sys.System.invoke('open $directory');
  }

  static Future<void> openInEditor(String directory) async {
    if (Platform.isMacOS) {
      sys.System.invoke('$macVsCodePath $directory > /dev/null 2>&1 &');
    }
    if (Platform.isLinux) {
      sys.System.invoke('code $directory');
    }
  }

  static Future<void> openInApp([String? directory = '']) async {
    if (Platform.isMacOS) {
      sys.System.invoke(
        '/Applications/logbook.app/Contents/MacOS/logbook $directory > /dev/null 2>&1  &',
      );
      return;
    }
    if (Platform.isLinux) {
      var home = path.absolute(Platform.environment['HOME']!);
      sys.System.invoke(
        '$home/bin/logbook/logbook $directory > /dev/null 2>&1 &',
      );
      return;
    }
    throw 'Unsupported OS';
  }

  static Future<void> archive(String originalDirectoryPath) async {
    final Directory originalDirectory = Directory(originalDirectoryPath);
    if (!originalDirectory.existsSync()) {
      return;
    }
    var archivedDirectoryPath = originalDirectoryPath.replaceFirst(
      baseDir.path,
      archiveDir.path,
    );
    final Directory archivedDirectory = Directory(archivedDirectoryPath);
    await archivedDirectory.create(recursive: true);
    await originalDirectory.rename(archivedDirectoryPath);

    final parentDayDirectory = originalDirectory.parent;
    final parentMonthDirectory = parentDayDirectory.parent;
    final parentYearDirectory = parentMonthDirectory.parent;

    if (await parentDayDirectory.list().isEmpty) {
      await parentDayDirectory.delete();
    }
    if (await parentMonthDirectory.list().isEmpty) {
      await parentMonthDirectory.delete();
    }
    if (await parentYearDirectory.list().isEmpty) {
      await parentYearDirectory.delete();
    }
  }

  static Directory get baseDir {
    return LogbookConfig().logDirectory;
  }

  static Directory get archiveDir {
    var result = LogbookConfig().archiveDirectory;
    return result;
  }
}
