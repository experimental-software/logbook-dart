class LogEntry {
  final DateTime dateTime;
  final String title;
  final String directory;

  LogEntry({
    required this.dateTime,
    required this.title,
    required this.directory,
  });

  String get formattedTime {
    var year = dateTime.year.toString();
    var month = dateTime.month.toString().padLeft(2, '0');
    var day = dateTime.day.toString().padLeft(2, '0');
    var hour = dateTime.hour.toString().padLeft(2, '0');
    var minute = dateTime.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }

  String get path {
    var slugMatcher = RegExp(r'\d{2}\.\d{2}_(.*)');
    var slugMatch = slugMatcher.firstMatch(directory);
    if (slugMatch == null) {
      throw 'Could not parse slug for $directory';
    }
    var slug = slugMatch.group(1);
    if (slug == null) {
      throw 'Could not parse slug for $directory';
    }
    return '$directory/$slug.md';
  }
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
