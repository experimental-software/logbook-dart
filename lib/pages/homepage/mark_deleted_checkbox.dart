import 'package:flutter/material.dart';

import '../../core/log_entry.dart';
import 'index.dart';

class MarkDeletedCheckbox extends StatefulWidget {
  final LogEntry logEntry;
  final Set<LogEntry> markedForDeletion;
  final Function notifyParent;

  const MarkDeletedCheckbox({
    Key? key,
    required this.markedForDeletion,
    required this.logEntry,
    required this.notifyParent,
  }) : super(
          key: key,
        );

  @override
  State<MarkDeletedCheckbox> createState() => _MarkDeletedCheckboxState();
}

class _MarkDeletedCheckboxState extends State<MarkDeletedCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      key: ValueKey(widget.logEntry.dateTime.toIso8601String()),
      value: isChecked,
      onChanged: (bool? value) {
        if (value == null) {
          return;
        }

        if (value) {
          widget.markedForDeletion.add(widget.logEntry);
        } else {
          widget.markedForDeletion.remove(widget.logEntry);
        }

        setState(() {
          isChecked = value;
          widget.notifyParent();
        });
      },
    );
  }
}
