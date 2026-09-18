import 'package:flutter/widgets.dart';

/// What the current look asks of individual widgets, resolved once near the
/// root of the app.
///
/// Widgets read their behaviour from here rather than inferring it from which
/// ancestors happen to exist, so each part of a look can be switched on and
/// off on its own.
class AppearanceScope extends InheritedWidget {
  const AppearanceScope({
    required this.terminalPrompt,
    required this.animate,
    required super.child,
    super.key,
  });

  /// Show search fields as a command line: a `$` prompt and block cursor.
  final bool terminalPrompt;

  /// Whether decorative motion runs: the moving scanline band, glitching
  /// labels and the blinking cursor. Already folds in the system's "remove
  /// animations" setting.
  final bool animate;

  /// The look outside any scope, e.g. in widget tests.
  static const _fallback = AppearanceScope(
    terminalPrompt: false,
    animate: true,
    child: SizedBox.shrink(),
  );

  static AppearanceScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppearanceScope>() ??
      _fallback;

  @override
  bool updateShouldNotify(AppearanceScope oldWidget) =>
      terminalPrompt != oldWidget.terminalPrompt ||
      animate != oldWidget.animate;
}
