import 'package:flutter/material.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/features/home/home_state.dart';

Future<void> renameApp({
  required BuildContext context,
  required String packageName,
  required String currentLabel,
  required String originalLabel,
  required AppListState appListState,
  required HomeState homeState,
}) async {
  final newLabel = await showRenameDialog(
    context: context,
    currentLabel: currentLabel,
    originalLabel: originalLabel,
  );
  if (newLabel != null) {
    appListState.setCustomLabel(packageName, newLabel);
    await homeState.renameApp(packageName, newLabel);
  }
}

Future<String?> showRenameDialog({
  required BuildContext context,
  required String currentLabel,
  required String originalLabel,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _RenameDialog(
      currentLabel: currentLabel,
      originalLabel: originalLabel,
    ),
  );
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({
    required this.currentLabel,
    required this.originalLabel,
  });

  final String currentLabel;
  final String originalLabel;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentLabel);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: widget.originalLabel),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
