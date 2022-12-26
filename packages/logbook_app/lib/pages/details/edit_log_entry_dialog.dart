import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_app/pages/details/reload_bloc/reload_bloc.dart';
import 'package:logbook_app/state.dart';
import 'package:logbook_core/logbook_core.dart';

import '../homepage/index.dart';

class EditLogEntryDialog extends StatefulWidget {
  final LogEntry logEntry;
  final String previousDescription;
  final ReloadBloc reloadBloc;

  const EditLogEntryDialog({
    Key? key,
    required this.logEntry,
    required this.previousDescription,
    required this.reloadBloc,
  }) : super(key: key);

  @override
  State<EditLogEntryDialog> createState() => _EditLogEntryDialogState();
}

class _EditLogEntryDialogState extends State<EditLogEntryDialog> {
  final WriteService writeService = GetIt.I.get();
  final ReadService readService = GetIt.I.get();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.logEntry.title;
    _descriptionController.text = widget.previousDescription;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit log entry'),
      children: [
        SizedBox(
          width: 900,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 40,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                var title = _titleController.text;
                var description = _descriptionController.text;

                writeService
                    .updateLogEntry(
                  logEntry: widget.logEntry,
                  title: title,
                  description: description,
                )
                    .then((logEntry) {
                  final logbookBloc = context.read<LogbookBloc>();

                  Navigator.pop(context);
                  widget.reloadBloc.add(LogEntryEdited(widget.logEntry.path));

                  logEntriesChanged.value += 1;
                  logbookBloc.add(LogUpdated());
                });
              },
              child: const Text('Save'),
            )
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

Future<void> showEditLogEntryDialog({
  required BuildContext context,
  required LogEntry logEntry,
  required String previousDescription,
}) async {
  final ReloadBloc reloadBloc = context.read<ReloadBloc>();
  await showDialog(
    context: context,
    builder: (context) {
      return EditLogEntryDialog(
        logEntry: logEntry,
        previousDescription: previousDescription,
        reloadBloc: reloadBloc,
      );
    },
    barrierDismissible: false,
  );
}
