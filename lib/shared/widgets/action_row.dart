import 'package:flutter/material.dart';
import 'package:last_launcher/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onClose,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: AppLabel.verticalPadding,
                bottom: AppLabel.verticalPadding,
              ),
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
          ),
          for (final action in actions)
            _ActionIcon(
              icon: action.icon,
              label: action.label,
              color: colorScheme.onSurface,
              onTap: () {
                action.onTap();
                onClose();
              },
            ),
          _ActionIcon(
            icon: Icons.close,
            label: l10n.actionClose,
            color: colorScheme.onSurface,
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Tooltip(
          message: label,
          child: SizedBox.square(
            dimension: 48,
            child: Center(child: Icon(icon, color: color, size: 22)),
          ),
        ),
      ),
    );
  }
}
