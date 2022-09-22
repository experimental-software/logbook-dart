import 'dart:io';

class ReadService {
  Future<String> readDescriptionLogOrNoteDescriptionFile(Directory dir) async {
    var files = dir.listSync();

    final timeAndSlugMatcher = RegExp(r'.*/\d{2}.\d{2}_(.*)');
    var timeAndSlugMatch = timeAndSlugMatcher.firstMatch(dir.path)!;
    var slug = timeAndSlugMatch.group(1)!;

    var result = 'not found';
    for (var file in files) {
      if (file.path.endsWith('$slug.md') || file.path.endsWith('index.md')) {
        var f = File(file.path);
        result = f.readAsStringSync();
        break;
      }
    }
    return result;
  }
}
