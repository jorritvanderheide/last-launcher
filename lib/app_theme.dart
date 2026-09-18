import 'package:flutter/material.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

/// The parts of the look that end up in [ThemeData]. A record, so equal
/// looks compare equal and each theme is only ever built once.
typedef ThemeSpec = ({bool mono, bool glow, AccentColors? accent});

final _themes = <(Brightness, ThemeSpec, bool), ThemeData>{};

/// The theme for [brightness] and [spec], built once and then reused.
ThemeData themeFor(
  Brightness brightness,
  ThemeSpec spec, {
  bool settings = false,
}) => _themes.putIfAbsent((
  brightness,
  spec,
  settings,
), () => buildLauncherTheme(brightness, spec, settings: settings));

/// The app's theme. With [settings] set, the variant for settings pages:
/// text and backgrounds stay plain, and only the highlights (titles and
/// headings, icons, switches, sliders, focused fields) take the accent.
@visibleForTesting
ThemeData buildLauncherTheme(
  Brightness brightness,
  ThemeSpec spec, {
  bool settings = false,
}) {
  final isDark = brightness == Brightness.dark;
  final accent = spec.accent;
  final plain = isDark ? Colors.white : Colors.black;
  final highlight = accent == null
      ? plain
      : (isDark ? accent.onDark : accent.onLight);
  final textColor = settings ? plain : highlight;
  final glowColor = textColor;

  // With the accent on, the launcher's backgrounds take on a faint tint of
  // it; settings pages stay plain.
  Color tinted(Color background) => accent == null || settings
      ? background
      : Color.alphaBlend(accent.tint.withAlpha(isDark ? 20 : 26), background);

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: highlight,
    onPrimary: isDark ? Colors.black : Colors.white,
    secondary: highlight,
    onSecondary: isDark ? Colors.black : Colors.white,
    surface: tinted(isDark ? Colors.black : Colors.white),
    onSurface: textColor,
    error: Colors.red,
    onError: Colors.white,
    inverseSurface: textColor,
    onInverseSurface: isDark ? Colors.black : Colors.white,
    surfaceContainerLow: tinted(
      isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
    ),
    surfaceContainer: tinted(
      isDark ? const Color(0xFF121212) : const Color(0xFFEEEEEE),
    ),
    surfaceContainerHigh: tinted(
      isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0),
    ),
    outline: isDark ? textColor.withAlpha(60) : Colors.black26,
  );

  // Glow is one of the effects that only exist in dark mode.
  final shadows = spec.glow && isDark
      ? [
          Shadow(color: glowColor.withAlpha(120), blurRadius: 8),
          Shadow(color: glowColor.withAlpha(70), blurRadius: 24),
        ]
      : <Shadow>[];

  final applied = ThemeData(brightness: brightness).textTheme.apply(
    fontFamily: spec.mono ? 'JetBrainsMono' : null,
    bodyColor: textColor,
    displayColor: textColor,
  );
  final textTheme = applied.copyWith(
    titleLarge: applied.titleLarge?.copyWith(shadows: shadows),
    titleMedium: applied.titleMedium?.copyWith(shadows: shadows),
    titleSmall: applied.titleSmall?.copyWith(shadows: shadows),
    bodyLarge: applied.bodyLarge?.copyWith(shadows: shadows),
    bodyMedium: applied.bodyMedium?.copyWith(shadows: shadows),
    bodySmall: applied.bodySmall?.copyWith(shadows: shadows),
    labelLarge: applied.labelLarge?.copyWith(shadows: shadows),
    labelMedium: applied.labelMedium?.copyWith(shadows: shadows),
    labelSmall: applied.labelSmall?.copyWith(shadows: shadows),
  );

  return ThemeData(
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
      // Titles and their icons take the accent. Set as a colour rather
      // than a title style: the theme has no font sizes yet at this point
      // (they're added per script when the app starts), so a copied style
      // would lose its size.
      foregroundColor: highlight,
    ),
    // Row icons on settings pages take the accent too; without one they
    // keep Material's own softer icon colour.
    listTileTheme: settings && accent != null
        ? ListTileThemeData(iconColor: highlight)
        : null,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.surface,
      foregroundColor: textColor,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      shape: const RoundedRectangleBorder(),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(),
    ),
    dialogTheme: const DialogThemeData(shape: RoundedRectangleBorder()),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: highlight, width: 1.5),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final disabled = states.contains(WidgetState.disabled);
        final base = selected ? highlight : colorScheme.outline;
        return disabled ? base.withAlpha(80) : base;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        final disabled = states.contains(WidgetState.disabled);
        if (selected) {
          return highlight.withAlpha(disabled ? 30 : 60);
        }
        return colorScheme.surface;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? colorScheme.outline.withAlpha(60)
            : colorScheme.outline;
      }),
    ),
    dividerTheme: const DividerThemeData(space: 0, thickness: 0),
  );
}
