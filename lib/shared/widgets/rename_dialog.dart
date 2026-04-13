import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';

Future<String?> showRenameDialog({
  required BuildContext context,
  required String currentLabel,
  required String originalLabel,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) =>
        _RenameDialog(currentLabel: currentLabel, originalLabel: originalLabel),
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
    _controller = TextEditingController(text: widget.currentLabel)
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.currentLabel.length,
      );
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.renameDialogTitle),
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
          child: Text(l10n.renameDialogCancel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.renameDialogSave)),
      ],
    );
  }
}
