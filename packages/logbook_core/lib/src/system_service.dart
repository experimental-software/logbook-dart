import 'dart:io';

import 'package:logbook_core/src/config.dart';

class SystemService {
  Future<String> archive(String originalDirectoryPath) async {
    return await System.archive(originalDirectoryPath);
  }

  void shutdownApp() {
    exit(0);
  }
}

class System {
  System._();

  static Future<String> archive(String path) async {
    var pattern = RegExp(r'(.*/\d{4}/\d{2}/\d{2}/\d{2}\.\d{2}_.*?)(/.*)?$');
    var match = pattern.firstMatch(path);
    if (match == null) {
      throw "Cannot archive '$path'. Reason: Invalid path.";
    }

    var originalDirectoryPath = match.group(1);
    if (originalDirectoryPath == null) {
      throw "Cannot archive '$path'. Reason: Invalid path.";
    }

    final Directory originalDirectory = Directory(originalDirectoryPath);
    if (!originalDirectory.existsSync()) {
      throw "Cannot archive '$originalDirectoryPath'. Reason: directory not found.";
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

    return archivedDirectoryPath;
  }

  static Directory get baseDir {
    return LogbookConfig().logDirectory;
  }

  static Directory get archiveDir {
    var result = LogbookConfig().archiveDirectory;
    return result;
  }
}
