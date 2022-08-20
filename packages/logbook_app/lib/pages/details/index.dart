import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/create_log_dialog.dart';
import '../homepage/index.dart';
import 'action_buttons.dart';
import 'reload_bloc/reload_bloc.dart';

class DetailsPage extends StatefulWidget {
  final LogEntry logEntry;

  const DetailsPage({
    Key? key,
    required this.logEntry,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<String> _noteText;

  @override
  void initState() {
    _fetchNoteText();
    super.initState();
  }

  void _fetchNoteText({Directory? noteDirectory}) {
    _noteText = _readNoteText(noteDirectory);
    setState(() {});
  }

  Future<String> _readNoteText(Directory? dir) async {
    dir ??= Directory(widget.logEntry.directory);
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
    return BlocProvider(
      create: (context) => ReloadBloc(),
      child: BlocListener<ReloadBloc, ReloadState>(
        listener: (context, ReloadState state) {
          if (state is Loading) {
            _fetchNoteText(noteDirectory: state.noteDirectory);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.logEntry.title),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _showCreateLogDialog(context);
              logEntriesChanged.value += 1;
            },
            tooltip: 'Add log entry',
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              const SizedBox(height: 15),
              ActionButtons(logEntry: widget.logEntry),
              const SizedBox(height: 15),
              FutureBuilder<String>(
                future: _noteText,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }

                  var data = snapshot.data!;
                  data = data.replaceFirst(RegExp(r'^#.*'), '');

                  if (data.trim().isEmpty) {
                    return Container();
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 87),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
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
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateLogDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return const CreateLogDialog();
      },
      barrierDismissible: false,
    );
  }
}
