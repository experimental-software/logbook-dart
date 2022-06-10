import 'dart:io';

import 'package:flutter/services.dart';
import 'package:system/system.dart' as sys;

class System {
  System._();

  static Future<void> openDirectory(String directory) async {
    sys.System.invoke('open $directory');
  }

  static Future<void> openInEditor(String directory) async {
    if (Platform.isMacOS) {
      sys.System.invoke(
          '/Applications/Visual\\ Studio\\ Code.app/Contents/MacOS/Electron $directory &');
    }
    if (Platform.isLinux) {
      sys.System.invoke('code $directory');
    }
  }

  static Future<void> copyToClipboard(String text) async {
    Clipboard.setData(ClipboardData(text: text));
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

    final Directory originalParentDirectory = originalDirectory.parent;
    if (await originalParentDirectory.list().isEmpty) {
      await originalParentDirectory.delete();
    }
  }

  static Directory get baseDir {
    if (Platform.isMacOS) {
      return Directory('/Users/jmewes/doc/Notizen');
    }
    if (Platform.isLinux) {
      return Directory('/home/janux/doc/Notizen');
    }
    throw 'Unsupported OS: ${Platform.operatingSystem}';
  }

  static Directory get archiveDir {
    if (Platform.isMacOS) {
      return Directory('/Users/jmewes/doc/Archiv');
    }
    if (Platform.isLinux) {
      return Directory('/home/janux/doc/Archiv');
    }
    throw 'Unsupported OS: ${Platform.operatingSystem}';
  }
}
