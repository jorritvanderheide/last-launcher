import 'package:flutter/material.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';

class ActionItem {
  const ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class ActionRow extends StatelessWidget {
  const ActionRow({
    required this.label,
    required this.actions,
    required this.onClose,
    this.textDecoration,
    this.decorationThickness,
    this.opacity = 1.0,
    super.key,
  });

  final String label;
  final List<ActionItem> actions;
  final VoidCallback onClose;
  final TextDecoration? textDecoration;
  final double? decorationThickness;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onClose,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: AppLabel.verticalPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: Opacity(
                opacity: opacity,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppLabel.fontSize,
                    decoration: textDecoration,
                    decorationThickness: decorationThickness,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            ...actions.map((action) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  action.onTap();
                  onClose();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Tooltip(
                    message: action.label,
                    child: Icon(
                      action.icon,
                      color: colorScheme.onSurface,
                      size: 22,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
