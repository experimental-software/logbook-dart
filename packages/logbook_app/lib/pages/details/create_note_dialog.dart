import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logbook_core/logbook_core.dart';

class CreateNoteDialog extends StatefulWidget {
  final LogEntry parent;

  const CreateNoteDialog({
    Key? key,
    required this.parent,
  }) : super(key: key);

  @override
  State<CreateNoteDialog> createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<CreateNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  var textEditor = LogbookConfig().textEditor;

  bool shouldOpenInEditor = false;
  bool shouldCopyToClipboard = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add note to log entry'),
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
        Row(
          children: [
            if (textEditor != null) Row(
              children: [
                Checkbox(
                  value: shouldOpenInEditor,
                  onChanged: (bool? value) {
                    setState(() {
                      shouldOpenInEditor = value!;
                    });
                  },
                ),
                const Text('Open in editor'),
              ],
            ),
            if (textEditor != null)
              const SizedBox(width: 10),
            Row(
              children: [
                Checkbox(
                  value: shouldCopyToClipboard,
                  onChanged: (bool? value) {
                    setState(() {
                      shouldCopyToClipboard = value!;
                    });
                  },
                ),
                const Text('Path to clipboard'),
              ],
            ),
          ],
        ),
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

                createNoteEntry(
                  title: title,
                  description: description,
                  baseDir: Directory(widget.parent.directory),
                ).then((noteEntryDirectory) {
                  if (shouldOpenInEditor) {
                    var textEditor = LogbookConfig().textEditor!;
                    System.openInTextEditor(textEditor, noteEntryDirectory.path);
                  }

                  if (shouldCopyToClipboard) {
                    Clipboard.setData(ClipboardData(
                      text: noteEntryDirectory.path,
                    ));
                  }

                  Navigator.pop(context);
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

Future<void> showCreateNoteDialog(
  BuildContext context,
  LogEntry logEntry,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return CreateNoteDialog(parent: logEntry);
    },
    barrierDismissible: false,
  );
}
