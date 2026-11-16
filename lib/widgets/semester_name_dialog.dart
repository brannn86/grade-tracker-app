import 'package:flutter/material.dart';

// Returns the entered name, or null if the dialog was cancelled
Future<String?> showSemesterNameDialog(BuildContext context,
    {String? initialName}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _SemesterNameDialog(initialName: initialName),
  );
}

class _SemesterNameDialog extends StatefulWidget {
  final String? initialName;

  const _SemesterNameDialog({this.initialName});

  @override
  State<_SemesterNameDialog> createState() => _SemesterNameDialogState();
}

class _SemesterNameDialogState extends State<_SemesterNameDialog> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? "New semester" : "Rename semester"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: "e.g. Semester 1"),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(onPressed: _submit, child: const Text("Save")),
      ],
    );
  }
}
