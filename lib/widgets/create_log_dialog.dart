import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/writer.dart';

class CreateLogDialog extends StatefulWidget {
  const CreateLogDialog({Key? key}) : super(key: key);

  @override
  State<CreateLogDialog> createState() => _CreateLogDialogState();
}

class _CreateLogDialogState extends State<CreateLogDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add log entry'),
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () async {
            var title = _titleController.text;
            var description = _descriptionController.text;

            var logEntry = await createLogEntry(
              title: title,
              description: description,
            );
            Clipboard.setData(ClipboardData(text: logEntry.directory));

            Navigator.pop(context);
          },
          child: const Text('Save'),
        )
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
