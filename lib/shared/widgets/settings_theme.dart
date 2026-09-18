import 'package:flutter/material.dart';

/// The theme settings pages use, provided near the root of the app.
///
/// It's the app's theme with text and backgrounds kept plain black or white:
/// with an accent colour on, only the highlights (titles and headings,
/// icons, switches, sliders, focused fields) take it there, while the
/// launcher itself is themed throughout.
class SettingsTheme extends InheritedWidget {
  const SettingsTheme({required this.data, required super.child, super.key});

  final ThemeData data;

  static ThemeData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsTheme>()?.data;

  @override
  bool updateShouldNotify(SettingsTheme oldWidget) => data != oldWidget.data;
}

/// Puts [child], a settings page, under the [SettingsTheme].
class SettingsThemed extends StatelessWidget {
  const SettingsThemed({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final data = SettingsTheme.of(context);
    return data == null ? child : Theme(data: data, child: child);
  }
}
