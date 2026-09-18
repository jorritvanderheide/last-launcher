import 'package:flutter/widgets.dart';

/// What the current look asks of individual widgets, resolved once near the
/// root of the app.
///
/// Widgets read their behaviour from here rather than inferring it from which
/// ancestors happen to exist, so each part of a look can be switched on and
/// off on its own.
class AppearanceScope extends InheritedWidget {
  const AppearanceScope({
    required this.labelFontSize,
    this.labelAlign = TextAlign.left,
    required this.accentAvailable,
    required this.terminalPrompt,
    required this.animate,
    required super.child,
    super.key,
  });

  /// Font size of app labels and everything that lines up with them.
  final double labelFontSize;

  /// How app labels, and everything that lines up with them, are aligned:
  /// left, center or right.
  final TextAlign labelAlign;

  /// [labelAlign] as a horizontal [Alignment] x: -1, 0 or 1.
  double get labelAlignX => switch (labelAlign) {
    TextAlign.center => 0,
    TextAlign.right => 1,
    _ => -1,
  };

  CrossAxisAlignment get labelCrossAxis => switch (labelAlign) {
    TextAlign.center => CrossAxisAlignment.center,
    TextAlign.right => CrossAxisAlignment.end,
    _ => CrossAxisAlignment.start,
  };

  MainAxisAlignment get labelMainAxis => switch (labelAlign) {
    TextAlign.center => MainAxisAlignment.center,
    TextAlign.right => MainAxisAlignment.end,
    _ => MainAxisAlignment.start,
  };

  /// Row markers (the work-profile dot) sit on the edge the text leans to;
  /// centred text keeps them on the left.
  bool get markersOnRight => labelAlign == TextAlign.right;

  /// Whether the system has an accent colour to theme with (Android 12+).
  final bool accentAvailable;

  /// Show search fields as a command line: a `$` prompt and block cursor.
  final bool terminalPrompt;

  /// Whether decorative motion runs: the moving scanline band, glitching
  /// labels and the blinking cursor. Already folds in the system's "remove
  /// animations" setting.
  final bool animate;

  /// The look outside any scope, e.g. in widget tests.
  static const _fallback = AppearanceScope(
    labelFontSize: 28,
    accentAvailable: false,
    terminalPrompt: false,
    animate: true,
    child: SizedBox.shrink(),
  );

  static AppearanceScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppearanceScope>() ??
      _fallback;

  @override
  bool updateShouldNotify(AppearanceScope oldWidget) =>
      labelFontSize != oldWidget.labelFontSize ||
      labelAlign != oldWidget.labelAlign ||
      accentAvailable != oldWidget.accentAvailable ||
      terminalPrompt != oldWidget.terminalPrompt ||
      animate != oldWidget.animate;
}
