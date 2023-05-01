import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

import '../../widgets/create_log_dialog.dart';
import '../details/index.dart';
import 'logs_overview/mark_deleted_checkbox/index.dart';
import 'search_row/index.dart';
import 'state.dart';

final ValueNotifier<int> logEntriesChanged = ValueNotifier(0);

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final SearchService searchService = GetIt.I.get();

  final ScrollController _scrollController = ScrollController();

  final Set<LogEntry> _markedForDeletion = {};

  @override
  void initState() {
    logEntriesChanged.addListener(() {
      _updateLogEntryList();
    });

    //_updateLogEntryList();
    super.initState();
  }

  void _updateLogEntryList() {
    _markedForDeletion.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomepageBloc(),
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return BlocBuilder<HomepageBloc, HomepageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Logbook')),
          floatingActionButton: _buildFloatingActionButton(context),
          body: _buildBody(),
        );
      },
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SearchRow(),
          const SizedBox(height: 8),
          BlocBuilder<HomepageBloc, HomepageState>(
            builder: (context, state) {
              if (state is ShowingLogs) {
                return _buildLogEntryTable(state.logs);
              } else if (state is SearchingLogs) {
                return const CircularProgressIndicator();
              } else if (state is NoSearchResults) {
                return const Text('No search results');
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await _showCreateLogDialog(context);
        _updateLogEntryList();
      },
      tooltip: 'Add log entry',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildLogEntryTable(List<LogEntry> logEntries) {
    return Flexible(
      child: Row(
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 8,
              controller: _scrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: <DataColumn>[
                    DataColumn(
                      label: _markedForDeletion.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                for (var logEntry in _markedForDeletion) {
                                  try {
                                    await System.archive(logEntry.directory);
                                    logEntries.remove(logEntry);
                                  } catch (e) {
                                    _showErrorDialog(context, e);
                                    rethrow;
                                  }
                                }
                                _markedForDeletion.clear();
                                _updateLogEntryList();
                              },
                            )
                          : const Text(''),
                    ),
                    const DataColumn(
                      label: Text('Date/Time'),
                    ),
                    const DataColumn(
                      label: Text('Titel'),
                    ),
                    const DataColumn(
                      label: Text(''),
                    ),
                  ],
                  rows: _buildTableRows(context, logEntries),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context, Object e) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: TextFormField(
              initialValue: e.toString(),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<DataRow> _buildTableRows(
    BuildContext context,
    List<LogEntry> logEntries,
  ) {
    var deviceInfo = MediaQuery.of(context);
    const widthDateTimeColumn = 130.0;
    const widthActionsColumn = 410.0;
    final widthTitleColumn =
        deviceInfo.size.width - widthDateTimeColumn - widthActionsColumn;
    var textEditor = LogbookConfig().textEditor;

    return logEntries
        .map((logEntry) => DataRow(
              onSelectChanged: (value) {
                if (value == null || !value) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      originalLogEntry: logEntry,
                    ),
                  ),
                );
              },
              cells: [
                DataCell(
                  MarkDeletedCheckbox(
                    key: ValueKey(logEntry.dateTime),
                    markedForDeletion: _markedForDeletion,
                    logEntry: logEntry,
                    notifyParent: () {
                      setState(() {});
                    },
                  ),
                ),
                DataCell(SizedBox(
                  width: widthDateTimeColumn,
                  child: Text(_formatTime(logEntry.dateTime)),
                )),
                DataCell(SizedBox(
                  width: widthTitleColumn,
                  child: Text(logEntry.title),
                )),
                DataCell(
                  SizedBox(
                      width: widthActionsColumn,
                      child: Row(
                        children: [
                          if (textEditor != null)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                System.openInTextEditor(
                                  textEditor,
                                  logEntry.directory,
                                );
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.folder),
                            onPressed: () {
                              System.openInFileExplorer(
                                logEntry.directory,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                text: logEntry.directory,
                              ));
                            },
                          ),
                        ],
                      )),
                ),
              ],
            ))
        .toList();
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

String _formatTime(DateTime t) {
  var year = t.year.toString();
  var month = t.month.toString().padLeft(2, '0');
  var day = t.day.toString().padLeft(2, '0');
  var hour = t.hour.toString().padLeft(2, '0');
  var minute = t.minute.toString().padLeft(2, '0');

  return '$year-$month-$day $hour:$minute';
}
