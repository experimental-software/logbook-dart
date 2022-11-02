import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logbook_core/logbook_core.dart';
import 'package:get_it/get_it.dart';

import '../../widgets/create_log_dialog.dart';
import '../details/index.dart';
import 'mark_deleted_checkbox.dart';

final ValueNotifier<int> logEntriesChanged = ValueNotifier(0);

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final SearchService searchService = GetIt.I.get();
  final TextEditingController _searchTermController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Future<List<LogEntry>> _logEntries;
  final Set<LogEntry> _markedForDeletion = {};
  bool useRegexSearch = false;
  bool negateSearch = false;

  @override
  void initState() {
    logEntriesChanged.addListener(() {
      _updateLogEntryList();
    });

    _updateLogEntryList();
    super.initState();
  }

  void _updateLogEntryList() {
    var searchTerm = _searchTermController.text.trim();
    _logEntries = searchService.search(
      System.baseDir,
      searchTerm,
      isRegularExpression: useRegexSearch,
      negateSearch: negateSearch,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logbook')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showCreateLogDialog(context);
          _updateLogEntryList();
        },
        tooltip: 'Add log entry',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            _buildSearchRow(),
            const SizedBox(height: 15),
            FutureBuilder<List<LogEntry>>(
              future: _logEntries,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return _buildLogEntryTable(snapshot.data!);
                } else {
                  return _buildLogEntryTable([]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            width: 200,
            child: TextField(
              controller: _searchTermController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search log entries...',
                suffixIcon: Column(
                  children: [
                    InkWell(
                      child: useRegexSearch
                          ? const Icon(Icons.emergency, size: 20)
                          : const Icon(Icons.emergency_outlined, size: 20),
                      onTap: () {
                        setState(() {
                          useRegexSearch = !useRegexSearch;
                          _updateLogEntryList();
                        });
                      },
                    ),
                    InkWell(
                      child: negateSearch
                          ? const Icon(Icons.remove_circle, size: 20)
                          : const Icon(Icons.remove_circle_outline, size: 20),
                      onTap: () {
                        setState(() {
                          negateSearch = !negateSearch;
                          _updateLogEntryList();
                        });
                      },
                    ),
                  ],
                ),
              ),
              onSubmitted: (query) {
                _updateLogEntryList();
                setState(() {});
              },
              autofocus: true,
            ),
          ),
        )
      ],
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
                      label: Text('Actions'),
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
    const widthDateTimeColumn = 140.0;
    const widthActionsColumn = 412.0;
    final widthTitleColumn =
        deviceInfo.size.width - widthDateTimeColumn - widthActionsColumn;

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
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              System.openInEditor(logEntry.directory);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.folder),
                            onPressed: () {
                              System.openDirectory(logEntry.directory);
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
    _searchTermController.dispose();
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
