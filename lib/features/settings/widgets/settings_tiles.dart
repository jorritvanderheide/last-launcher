import 'package:flutter/material.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/widgets/fade_overflow.dart';

/// Opens a settings page. Pages switch instantly, like the rest of the
/// launcher.
Future<void> pushSettingsPage(BuildContext context, Widget page) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

/// The frame every settings page shares: a title bar, a fading list and room
/// for the navigation bar at the end.
///
/// Rows are rebuilt whenever [listenable] fires, if given, since whether a
/// row is enabled often depends on other settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.title,
    required this.children,
    this.listenable,
    super.key,
  });

  final String title;
  final Listenable? listenable;
  final List<Widget> Function(BuildContext context) children;

  @override
  Widget build(BuildContext context) {
    Widget list(BuildContext context) => FadeOverflow(
      child: ListView(
        // Starts below the fade, so the first row isn't dimmed at rest.
        padding: const EdgeInsets.only(top: FadeOverflow.defaultSize),
        children: [
          ...children(context),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 8),
        ],
      ),
    );

    final listenable = this.listenable;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: listenable == null
          ? Builder(builder: list)
          : ListenableBuilder(
              listenable: listenable,
              builder: (context, _) => list(context),
            ),
    );
  }
}

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// A switch bound to a boolean [Setting].
///
/// When another setting decides this one, pass [enabled] false and the value
/// actually in effect as [effective]: the row then says what applies, while
/// the user's own choice stays stored and returns once the row is enabled
/// again. [indent] marks a row that refines the one above it.
class SettingSwitch extends StatelessWidget {
  const SettingSwitch({
    required this.setting,
    required this.title,
    this.subtitle,
    this.enabled = true,
    this.effective,
    this.indent = false,
    super.key,
  });

  final Setting<bool> setting;
  final String title;
  final String? subtitle;
  final bool enabled;
  final bool? effective;
  final bool indent;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: indent
          ? const EdgeInsetsDirectional.only(start: 40, end: 24)
          : null,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      value: effective ?? setting.value,
      onChanged: enabled ? (value) => setting.value = value : null,
    );
  }
}

/// A slider bound to a numeric [Setting], moving in steps of [step], with
/// the current value shown next to it.
///
/// The setting is written once, when the user lets go, rather than on every
/// step while dragging.
class SettingSlider extends StatefulWidget {
  const SettingSlider({
    required this.setting,
    required this.title,
    required this.min,
    required this.max,
    required this.step,
    this.leading,
    super.key,
  });

  final Setting<double> setting;
  final String title;
  final double min;
  final double max;
  final double step;
  final Widget? leading;

  @override
  State<SettingSlider> createState() => _SettingSliderState();
}

class _SettingSliderState extends State<SettingSlider> {
  /// The value under the user's finger, until they let go.
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final value = _dragging ?? widget.setting.value;
    final shown = value.round().toString();
    return ListTile(
      leading: widget.leading,
      title: Text(widget.title),
      trailing: Text(shown, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Slider(
        value: value,
        min: widget.min,
        max: widget.max,
        divisions: ((widget.max - widget.min) / widget.step).round(),
        label: shown,
        onChanged: (value) => setState(() => _dragging = value),
        onChangeEnd: (value) {
          widget.setting.value = value;
          setState(() => _dragging = null);
        },
      ),
    );
  }
}

/// A row showing the current choice, which opens a picker when tapped.
///
/// [subtitle] replaces the current-choice summary, for instance to say why
/// the row is disabled. A null [onChanged] disables the row.
class ChoiceTile<T> extends StatelessWidget {
  const ChoiceTile({
    required this.title,
    required this.value,
    required this.options,
    required this.label,
    required this.onChanged,
    this.subtitle,
    this.leading,
    super.key,
  });

  final String title;
  final T value;
  final List<T> options;
  final String Function(BuildContext context, T option) label;
  final ValueChanged<T>? onChanged;
  final String? subtitle;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: Text(subtitle ?? label(context, value)),
      enabled: onChanged != null,
      onTap: onChanged == null
          ? null
          : () async {
              final result = await showDialog<T>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(title),
                  children: [
                    RadioGroup<T>(
                      groupValue: value,
                      onChanged: (option) => Navigator.pop(context, option),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final option in options)
                            RadioListTile<T>(
                              value: option,
                              title: Text(label(context, option)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              if (result != null) onChanged(result);
            },
    );
  }
}
