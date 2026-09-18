import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/app.dart';
import 'package:last_launcher/features/settings/widgets/settings_tiles.dart';
import 'package:last_launcher/shared/widgets/settings_theme.dart';

const _accent = (
  onDark: Color(0xFFB0F2B0),
  onLight: Color(0xFF1B5E20),
  tint: Color(0xFF4CAF50),
);
const ThemeSpec _withAccent = (mono: false, glow: false, accent: _accent);
const ThemeSpec _plain = (mono: false, glow: false, accent: null);

void main() {
  group('with an accent', () {
    final launcher = buildLauncherTheme(Brightness.dark, _withAccent);
    final settings = buildLauncherTheme(
      Brightness.dark,
      _withAccent,
      settings: true,
    );

    test('the launcher is themed throughout', () {
      expect(launcher.colorScheme.onSurface, _accent.onDark);
      expect(launcher.textTheme.bodyLarge?.color, _accent.onDark);
      expect(launcher.colorScheme.surface, isNot(Colors.black));
    });

    test('settings keep text and backgrounds plain', () {
      expect(settings.colorScheme.onSurface, Colors.white);
      expect(settings.textTheme.bodyLarge?.color, Colors.white);
      expect(settings.appBarTheme.foregroundColor, Colors.white);
      expect(settings.colorScheme.surface, Colors.black);
    });

    test('settings still theme their highlights', () {
      // Section headings and sliders use the primary colour.
      expect(settings.colorScheme.primary, _accent.onDark);
      final thumb = settings.switchTheme.thumbColor!.resolve({
        WidgetState.selected,
      });
      expect(thumb, _accent.onDark);
    });

    test('in light mode too', () {
      final light = buildLauncherTheme(
        Brightness.light,
        _withAccent,
        settings: true,
      );
      expect(light.colorScheme.onSurface, Colors.black);
      expect(light.colorScheme.primary, _accent.onLight);
    });
  });

  test('without an accent, settings look like the rest', () {
    final launcher = buildLauncherTheme(Brightness.dark, _plain);
    final settings = buildLauncherTheme(
      Brightness.dark,
      _plain,
      settings: true,
    );
    expect(settings.colorScheme, launcher.colorScheme);
  });

  testWidgets('settings pages open in the settings theme', (tester) async {
    final settingsTheme = buildLauncherTheme(
      Brightness.dark,
      _withAccent,
      settings: true,
    );
    late Color pageText;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLauncherTheme(Brightness.dark, _withAccent),
        builder: (context, child) =>
            SettingsTheme(data: settingsTheme, child: child!),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => pushSettingsPage(
              context,
              Builder(
                builder: (context) {
                  pageText = Theme.of(context).colorScheme.onSurface;
                  return const SizedBox.shrink();
                },
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(pageText, Colors.white);
  });
}
