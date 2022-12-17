import 'dart:io';
import 'package:yaml/yaml.dart';

String get _defaultConfig {
  return '''
logDirectory: $_defaultLogDirectory
archiveDirectory: $_defaultArchiveDirectory
  ''';
}

String get _configFilePath {
  return '${LogbookConfig.homeDirectory.path}'
      '${Platform.pathSeparator}'
      '.config'
      '${Platform.pathSeparator}'
      'logbook'
      '${Platform.pathSeparator}'
      'config.yaml';
}

String get _defaultLogDirectory {
  return '${LogbookConfig.homeDirectory.path}'
      '${Platform.pathSeparator}'
      'Logs';
}

String get _defaultArchiveDirectory {
  return '${LogbookConfig.homeDirectory.path}'
      '${Platform.pathSeparator}'
      'Archive';
}

class LogbookConfig {
  static Directory? _customizedHomeDirectory;

  dynamic _config;

  LogbookConfig() {
    File configFile = File(_configFilePath);
    if (configFile.existsSync()) {
      try {
        _config = loadYaml(configFile.readAsStringSync());
      } catch (_) {
        _config = loadYaml(_defaultConfig);
      }
    } else {
      _config = loadYaml(_defaultConfig);
    }
  }

  Directory get logDirectory {
    String? path = _config['logDirectory'];
    path ??= _defaultLogDirectory;
    path = path.replaceFirst('~', LogbookConfig.homeDirectory.path);
    return Directory(path);
  }

  Directory get archiveDirectory {
    String? path = _config['archiveDirectory'];
    path ??= _defaultArchiveDirectory;
    path = path.replaceFirst('~', LogbookConfig.homeDirectory.path);
    return Directory(path);
  }

  static set homeDirectory(Directory directory) {
    _customizedHomeDirectory = directory;
  }

  static Directory get homeDirectory {
    if (_customizedHomeDirectory != null) {
      return _customizedHomeDirectory!;
    }
    String? path;
    switch (Platform.operatingSystem) {
      case 'linux':
      case 'macos':
        path = Platform.environment['HOME'];
        break;
    }
    if (path == null) {
      throw 'Unsupported OS: ${Platform.operatingSystem}';
    }
    return Directory(path);
  }
}
