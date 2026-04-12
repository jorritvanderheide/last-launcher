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

  static const fontSize = 28.0;
  static const verticalPadding = 9.0;
  static const itemHeight = fontSize + 2 * verticalPadding;

  static int maxAppsFor(double availableHeight) {
    return (availableHeight / itemHeight).floor().clamp(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: verticalPadding,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontSize: fontSize),
        ),
      ),
    );
  }
}
