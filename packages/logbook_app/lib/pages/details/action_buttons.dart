import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

import '../../state.dart';
import '../../widgets/buttons.dart';
import '../homepage/index.dart';
import 'create_note_dialog.dart';

class ActionButtons extends StatelessWidget {
  final SystemService systemService = GetIt.I.get();
  final LogEntry logEntry;

  ActionButtons({required this.logEntry, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textEditor = LogbookConfig().textEditor;

    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (textEditor != null) const SizedBox(width: 10),
            PrimaryButton(
              'Add note',
              icon: Icons.note_add,
              onPressed: () async {
                await showCreateNoteDialog(context, logEntry);
              },
            ),
            const SizedBox(width: 7),
            if (textEditor != null)
              PrimaryButton(
                'Open in editor',
                icon: Icons.edit,
                onPressed: () {
                  System.openInTextEditor(
                    textEditor,
                    logEntry.directory,
                  );
                },
              ),
            const SizedBox(width: 7),
            PrimaryButton(
              Platform.operatingSystem == 'macos'
                  ? 'Open in Finder'
                  : 'Open in Nautilus',
              icon: Icons.folder,
              onPressed: () {
                System.openInFileExplorer(
                  logEntry.directory,
                );
              },
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 10),
              PrimaryButton(
                'Archive',
                icon: Icons.delete,
                onPressed: () {
                  final logbookBloc = context.read<LogbookBloc>();

                  systemService.archive(logEntry.directory).then((_) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);

                      logbookBloc.add(LogUpdated());
                      logEntriesChanged.value += 1;
                    } else {
                      systemService.shutdownApp();
                    }
                  });
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
