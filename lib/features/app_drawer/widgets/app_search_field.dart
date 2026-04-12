import 'package:flutter/material.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: AppLabel.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: (_) => onSubmit(),
            cursorWidth: 0,
            textInputAction: TextInputAction.go,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: AppLabel.fontSize),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isNotEmpty) return const SizedBox.shrink();
              return Container(
                width: 32,
                height: 2,
                color: colorScheme.onSurface,
              );
            },
          ),
        ],
      ),
    );
  }
}
