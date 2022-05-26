import 'dart:io';

import 'package:flutter/services.dart';
import 'package:system/system.dart' as sys;

class System {
  System._();

  static void openInExplorer(String directory) {
    sys.System.invoke("open $directory");
  }

  static void openInEditor(String directory) {
    sys.System.invoke("atom $directory");
  }

  static void copyToClipboard(String text) {
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
    throw "Unsupported OS: ${Platform.operatingSystem}";
  }
}