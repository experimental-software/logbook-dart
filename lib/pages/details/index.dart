import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logbook/core/log_entry.dart';
import 'package:logbook/pages/details/create_note_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../util/system.dart';
import '../homepage/create_log_dialog.dart';

class DetailsPage extends StatefulWidget {
  final LogEntry logEntry;
  final Function notifyParent;

  const DetailsPage({
    Key? key,
    required this.logEntry,
    required this.notifyParent,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<String> _contents;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    _contents = _readContents();
    setState(() {});
  }

  Future<String> _readContents() async {
    var dir = Directory(widget.logEntry.directory);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.logEntry.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showCreateLogDialog(context);
          widget.notifyParent();
        },
        tooltip: 'Add log entry',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildActionButtons(context),
            const SizedBox(height: 30),
            FutureBuilder<String>(
                future: _contents,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }

                  var data = snapshot.data!;
                  data = data.replaceFirst(RegExp(r'^#.*'), '');

                  return Expanded(
                    child: Markdown(
                      styleSheet: MarkdownStyleSheet(
                        h1Align: WrapAlignment.center,
                      ),
                      // shrinkWrap: false,
                      selectable: true,
                      onTapLink: (text, url, title) {
                        if (url != null) {
                          launchUrlString(url);
                        }
                      },
                      data: data,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            await _showCreateNoteDialog(context);
          },
          child: const Text('Add note'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            System.openInEditor(widget.logEntry.directory);
          },
          child: const Text('Open editor'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            System.openDirectory(widget.logEntry.directory);
          },
          child: const Text('Open directory'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            System.copyToClipboard(widget.logEntry.directory);
          },
          child: const Text('Copy to clipboard'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _fetchData,
          child: const Text('Reload'),
        ),
        const SizedBox(width: 500),
        ElevatedButton(
          onPressed: () {
            System.archive(widget.logEntry.directory).then((_) {
              Navigator.pop(context);
              widget.notifyParent();
            });
          },
          child: const Text('Archive'),
        ),
      ],
    );
  }

  Future<void> _showCreateLogDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateLogDialog(notifyParent: widget.notifyParent);
      },
      barrierDismissible: false,
    );
  }

  Future<void> _showCreateNoteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateNoteDialog(parent: widget.logEntry);
      },
      barrierDismissible: false,
    );
  }
}
