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
}