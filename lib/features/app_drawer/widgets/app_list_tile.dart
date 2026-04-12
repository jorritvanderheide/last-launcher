import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
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
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26),
        ),
      ),
    );
  }
}
