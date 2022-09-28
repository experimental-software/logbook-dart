import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logbook/pages/details/select_note_dialog/index.dart';
import 'package:logbook_core/logbook_core.dart';

import '../../widgets/buttons.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            PrimaryButton(
              'Add note',
              icon: Icons.add,
              onPressed: () async {
                await showCreateNoteDialog(context, logEntry);
              },
            ),
            const SizedBox(width: 15),
            PrimaryButton(
              'Open notes',
              icon: Icons.format_list_numbered,
              onPressed: () async {
                await showSelectNoteDialog(context, logEntry);
              },
            ),
            const SizedBox(width: 15),
            PrimaryButton(
              'Open directory',
              icon: Icons.folder,
              onPressed: () {
                System.openDirectory(logEntry.directory);
              },
            ),
            const SizedBox(width: 15),
            PrimaryButton(
              'Open editor',
              icon: Icons.edit,
              onPressed: () {
                System.openInEditor(logEntry.directory);
              },
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                'Copy to clipboard',
                icon: Icons.content_copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: logEntry.directory));
                },
              ),
              const SizedBox(width: 15),
              PrimaryButton(
                'Reload',
                icon: Icons.refresh,
                onPressed: () {
                  reloadBloc.add(LogEntryEdited(logEntry.path));
                },
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ],
    );
  }
}
