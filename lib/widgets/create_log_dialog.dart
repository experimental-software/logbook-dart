import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logbook/pages/details/index.dart';
import 'package:routemaster/routemaster.dart';

import '../core/log_entry.dart';
import '../core/writer.dart';
import '../pages/homepage/index.dart';
import '../util/system.dart';

class CreateLogDialog extends StatefulWidget {
  final Function notifyParent;

  const CreateLogDialog({
    Key? key,
    required this.notifyParent,
  }) : super(key: key);

  @override
  State<CreateLogDialog> createState() => _CreateLogDialogState();
}

class _CreateLogDialogState extends State<CreateLogDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool shouldOpenDetails = true;
  bool shouldOpenEditor = false;
  bool shouldOpenDirectory = false;

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Row(
              children: [
                Checkbox(
                  value: shouldOpenDetails,
                  onChanged: (bool? value) {
                    setState(() {
                      shouldOpenDetails = value!;
                    });
                  },
                ),
                const Text('Open details'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: shouldOpenEditor,
                  onChanged: (bool? value) {
                    setState(() {
                      shouldOpenEditor = value!;
                    });
                  },
                ),
                const Text('Open editor'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: shouldOpenDirectory,
                  onChanged: (bool? value) {
                    setState(() {
                      shouldOpenDirectory = value!;
                    });
                  },
                ),
                const Text('Open directory'),
              ],
            ),
          ],
        ),
        Row(
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
              onPressed: () {
                var title = _titleController.text;
                var description = _descriptionController.text;

                createLogEntry(
                  title: title,
                  description: description,
                ).then((logEntry) async {
                  buttonClickedTimes.value = buttonClickedTimes.value + 1;

                  Clipboard.setData(ClipboardData(text: logEntry.directory));

                  if (shouldOpenEditor) {
                    System.openInEditor(logEntry.directory);
                  }

                  if (shouldOpenDirectory) {
                    System.openDirectory(logEntry.directory);
                  }

                  Navigator.pop(context);

                  if (shouldOpenDetails) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DetailsPage(
                    //       logEntry: logEntry,
                    //       notifyParent: widget.notifyParent,
                    //     ),
                    //   ),
                    // );
                    var dir = encodePath(logEntry.directory);
                    print("hello: ${dir}");

                    Routemaster.of(context).push('/log-entry/$dir');
                  }
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
