class LogEntry {
  final DateTime dateTime;
  final String title;
  final String directory;

  LogEntry({
    required this.dateTime,
    required this.title,
    required this.directory,
  });
}

/// Notes are details within log entries.
class Note {
  final int index;
  final String title;
  final String directory;

  Note({
    required this.index,
    required this.title,
    required this.directory,
  });
}
