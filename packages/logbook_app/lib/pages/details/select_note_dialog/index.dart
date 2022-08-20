import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logbook_core/logbook_core.dart';
import 'package:get_it/get_it.dart';

import '../reload_bloc/reload_bloc.dart';

class SelectNoteDialog extends StatefulWidget {
  final LogEntry parent;
  final ReloadBloc reloadBloc;

  const SelectNoteDialog({
    Key? key,
    required this.parent,
    required this.reloadBloc,
  }) : super(key: key);

  @override
  State<SelectNoteDialog> createState() => _SelectNoteDialogState();
}

class _SelectNoteDialogState extends State<SelectNoteDialog> {
  final SearchService searchService = GetIt.I.get();
  final ScrollController _scrollController = ScrollController();

  late Future<List<Note>> _notes;

  @override
  void initState() {
    _notes = searchService.listNotes(widget.parent);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Notes'),
      children: [
        FutureBuilder<List<Note>>(
          future: _notes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return _buildNoteTable(snapshot.data!);
            }
          },
        ),
      ],
    );
  }

  Widget _buildNoteTable(List<Note> notes) {
    return Row(
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
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Index'),
                  ),
                  DataColumn(
                    label: Text('Title'),
                  ),
                  DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: _buildTableRows(context, notes),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow> _buildTableRows(BuildContext context, List<Note> notes) {
    var deviceInfo = MediaQuery.of(context);
    const widthIndexColumn = 20.0;
    const widthActionsColumn = 412.0;
    final widthTitleColumn =
        deviceInfo.size.width - widthIndexColumn - widthActionsColumn;

    return notes
        .map((note) => DataRow(
              onSelectChanged: (value) {
                if (value == null || !value) {
                  return;
                }
                widget.reloadBloc.add(NoteSelected(note));
                Navigator.pop(context);
              },
              cells: [
                DataCell(SizedBox(
                  width: widthIndexColumn,
                  child: Text(note.index.toString()),
                )),
                DataCell(SizedBox(
                  width: widthTitleColumn,
                  child: Text(note.title),
                )),
                DataCell(
                  SizedBox(
                      width: widthActionsColumn,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              System.openInEditor(note.directory);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.folder),
                            onPressed: () {
                              System.openDirectory(note.directory);
                            },
                          ),
                        ],
                      )),
                ),
              ],
            ))
        .toList();
  }
}

Future<void> showSelectNoteDialog(
    BuildContext context, LogEntry logEntry) async {

  final ReloadBloc reloadBloc = context.read<ReloadBloc>();

  await showDialog(
    context: context,
    builder: (context) {
      return SelectNoteDialog(parent: logEntry, reloadBloc: reloadBloc);
    },
    barrierDismissible: true,
  );
}
