import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logbook_core/logbook_core.dart';

import '../../state.dart';
import '../../widgets/buttons.dart';
import '../homepage/index.dart';
import 'create_note_dialog.dart';
import 'reload_bloc/reload_bloc.dart';

class ActionButtons extends StatelessWidget {
  final SystemService systemService = GetIt.I.get();
  final LogEntry logEntry;

  ActionButtons({required this.logEntry, Key? key}) : super(key: key);

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
              'Reload',
              icon: Icons.refresh,
              onPressed: () {
                reloadBloc.add(LogEntryEdited(logEntry.path));
              },
            ),
            const SizedBox(width: 15),
            PrimaryButton(
              'Copy to clipboard',
              icon: Icons.content_copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: logEntry.directory));
              },
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 15),
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
              const SizedBox(width: 15),
            ],
          ),
        ),
      ],
    );
  }
}
