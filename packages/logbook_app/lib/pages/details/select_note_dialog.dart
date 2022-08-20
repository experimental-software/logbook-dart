import 'package:flutter/material.dart';

import 'package:logbook_core/logbook_core.dart';
import 'package:get_it/get_it.dart';

class SelectNoteDialog extends StatefulWidget {
  final LogEntry parent;

  const SelectNoteDialog({
    Key? key,
    required this.parent,
  }) : super(key: key);

  @override
  State<SelectNoteDialog> createState() => _SelectNoteDialogState();
}

class _SelectNoteDialogState extends State<SelectNoteDialog> {
  final SearchService searchService = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Notes'),
      children: [

      ],
    );
  }
}

Future<void> showSelectNoteDialog(BuildContext context, LogEntry logEntry) async {
  await showDialog(
    context: context,
    builder: (context) {
      return SelectNoteDialog(parent: logEntry);
    },
    barrierDismissible: true,
  );
}
