import 'package:flutter/material.dart';

class PinnedAppLabel extends StatelessWidget {
  const PinnedAppLabel({
    required this.label,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(label, style: Theme.of(context).textTheme.titleLarge),
        ),
      ),
    );
  }
}
