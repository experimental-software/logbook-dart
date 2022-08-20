import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logbook_core/logbook_core.dart';

import '../../widgets/buttons.dart';
import '../homepage/index.dart';
import 'create_note_dialog.dart';
import 'reload_bloc/reload_bloc.dart';

class ActionButtons extends StatelessWidget {
  final LogEntry logEntry;

  const ActionButtons({required this.logEntry, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reloadBloc = context.read<ReloadBloc>();
    return Row(
      children: [
        const SizedBox(width: 15),
        PrimaryButton('➕ Add note', onPressed: () async {
          await showCreateNoteDialog(context, logEntry);
        }),
        const SizedBox(width: 15),
        PrimaryButton('🖊️ Open editor', onPressed: () {
          System.openInEditor(logEntry.directory);
        }),
        const SizedBox(width: 15),
        PrimaryButton('📁 Open directory', onPressed: () {
          System.openDirectory(logEntry.directory);
        }),
        const SizedBox(width: 15),
        PrimaryButton('📋 Copy to clipboard', onPressed: () {
          Clipboard.setData(ClipboardData(text: logEntry.directory));
        }),
        const SizedBox(width: 15),
        PrimaryButton('↩️Reload', onPressed: () {
          reloadBloc.add(UpdatedEvent());
        }),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton('🗑️ Archive', onPressed: () async {
                System.archive(logEntry.directory).then((_) {
                  Navigator.pop(context);
                  logEntriesChanged.value += 1;
                });
              }),
              const SizedBox(width: 15),
            ],
          ),
        )
      ],
    );
  }
}

Future<void> showCreateNoteDialog(BuildContext context, LogEntry logEntry) async {
  await showDialog(
    context: context,
    builder: (context) {
      return CreateNoteDialog(parent: logEntry);
    },
    barrierDismissible: false,
  );
}
