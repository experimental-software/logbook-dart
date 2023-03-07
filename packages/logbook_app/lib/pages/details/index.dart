import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_app/pages/homepage/index.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/create_log_dialog.dart';
import 'action_buttons.dart';
import 'edit_log_entry_dialog.dart';
import 'reload_bloc/reload_bloc.dart';

class DetailsPage extends StatefulWidget {
  final LogEntry originalLogEntry;

  const DetailsPage({
    Key? key,
    required this.originalLogEntry,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final SystemService systemService = GetIt.I.get();
  final ReadService readService = GetIt.I.get();

  late Future<String> _noteText;
  late Future<LogEntry> _currentLogEntry;

  @override
  void initState() {
    _currentLogEntry = Future.value(widget.originalLogEntry);
    _fetchNoteText();
    super.initState();
  }

  void _fetchNoteText({Directory? noteDirectory}) {
    _noteText = readService.readDescriptionLogOrNoteDescriptionFile(
      noteDirectory ?? Directory(widget.originalLogEntry.directory),
    );
    setState(() {});
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
          if (state is Reloading) {
            _currentLogEntry = toMandatoryLogEntry(state.logEntryPath);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Builder(builder: (context) {
              return BlocBuilder<ReloadBloc, ReloadState>(
                builder: (context, state) {
                  return GestureDetector(
                    onDoubleTap: () async {
                      var logEntry = await _currentLogEntry;
                      // ignore: use_build_context_synchronously
                      showEditLogEntryDialog(
                        context: context,
                        logEntry: logEntry,
                        previousDescription: await _noteText,
                      );
                    },
                    child: FutureBuilder<LogEntry>(
                        future: _currentLogEntry,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.title);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  );
                },
              );
            }),
          ),
          body: Column(
            children: [
              const SizedBox(height: 15),
              ActionButtons(logEntry: widget.originalLogEntry),
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

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            var logEntry = await _currentLogEntry;
                            // ignore: use_build_context_synchronously
                            showEditLogEntryDialog(
                              context: context,
                              logEntry: logEntry,
                              previousDescription: await _noteText,
                            );
                          },
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
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(context),
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await _showCreateLogDialog(context);
        logEntriesChanged.value += 1;
      },
      tooltip: 'Add log entry',
      child: const Icon(Icons.add),
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
