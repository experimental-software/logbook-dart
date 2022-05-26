import 'dart:io';

import 'package:flutter/services.dart';
import 'package:system/system.dart' as sys;

class System {
  System._();

  static Future<void> openInExplorer(String directory) async {
    sys.System.invoke('open $directory');
  }

  static Future<void> openInEditor(String directory) async {
    if (Platform.isMacOS) {
      sys.System.invoke(
          '/Applications/Atom.app/Contents/MacOS/atom $directory');
    }
    if (Platform.isLinux) {
      sys.System.invoke('atom $directory');
    }
  }

  static Future<void> copyToClipboard(String text) async {
    Clipboard.setData(ClipboardData(text: text));
  }

  static Future<void> delete(String file) async {
    await File(file).delete(recursive: true);
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
}
