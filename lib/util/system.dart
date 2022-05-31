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
          '/Applications/Atom.app/Contents/MacOS/atom $directory &');
    }
    if (Platform.isLinux) {
      sys.System.invoke('atom $directory');
    }
  }

  static Future<void> copyToClipboard(String text) async {
    Clipboard.setData(ClipboardData(text: text));
  }

  static Future<void> archive(String directory) async {
    var archivedDirectoryPath = directory.replaceFirst(
      baseDir.path,
      archiveDir.path,
    );
    final Directory archivedDirectory = Directory(archivedDirectoryPath);
    await archivedDirectory.create(recursive: true);
    await Directory(directory).rename(archivedDirectoryPath);
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
