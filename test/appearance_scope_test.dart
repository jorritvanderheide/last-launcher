import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/shared/widgets/app_label.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
import 'package:last_launcher/shared/widgets/scanline_overlay.dart';
import 'package:last_launcher/shared/widgets/search_field.dart';

Future<void> _pumpField(WidgetTester tester, {AppearanceScope? scope}) async {
  final field = AppSearchField(
    controller: TextEditingController(),
    focusNode: FocusNode(),
    onSubmit: () {},
  );
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: scope == null
            ? field
            : AppearanceScope(
                labelFontSize: scope.labelFontSize,
                labelAlign: scope.labelAlign,
                accentAvailable: scope.accentAvailable,
                terminalPrompt: scope.terminalPrompt,
                animate: scope.animate,
                child: field,
              ),
      ),
    ),
  );
}

void main() {
  testWidgets('search field is plain outside any scope', (tester) async {
    await _pumpField(tester);
    expect(find.text(r'$ '), findsNothing);
  });

  testWidgets('terminal prompt comes from the scope alone', (tester) async {
    await _pumpField(
      tester,
      scope: const AppearanceScope(
        labelFontSize: 28,
        accentAvailable: false,
        terminalPrompt: true,
        animate: false,
        child: SizedBox.shrink(),
      ),
    );
    expect(find.text(r'$ '), findsOneWidget);
  });

  group('scanlines', () {
    Future<ScanlineScope> pumpOverlay(
      WidgetTester tester, {
      required Brightness brightness,
      required double strength,
    }) async {
      late ScanlineScope scope;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: ScanlineOverlay(
            strength: strength,
            child: Builder(
              builder: (context) {
                scope = ScanlineScope.of(context)!;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      return scope;
    }

    testWidgets('draw in a dark theme', (tester) async {
      final scope = await pumpOverlay(
        tester,
        brightness: Brightness.dark,
        strength: 1,
      );
      expect(scope.active, isTrue);
    });

    testWidgets('stay off in a light theme', (tester) async {
      final scope = await pumpOverlay(
        tester,
        brightness: Brightness.light,
        strength: 1,
      );
      expect(scope.active, isFalse);
    });

    testWidgets('stay off at zero strength', (tester) async {
      final scope = await pumpOverlay(
        tester,
        brightness: Brightness.dark,
        strength: 0,
      );
      expect(scope.active, isFalse);
    });
  });

  group('alignment', () {
    Future<void> pumpLabel(WidgetTester tester, TextAlign align) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppearanceScope(
              labelFontSize: 28,
              labelAlign: align,
              accentAvailable: false,
              terminalPrompt: false,
              animate: false,
              child: const AppLabel(label: 'Camera'),
            ),
          ),
        ),
      );
    }

    testWidgets('labels follow the chosen alignment', (tester) async {
      await pumpLabel(tester, TextAlign.right);
      final text = tester.widget<Text>(find.text('Camera'));
      expect(text.textAlign, TextAlign.right);

      final label = tester.getTopRight(find.text('Camera')).dx;
      final screen = tester.getTopRight(find.byType(Scaffold)).dx;
      // Flush right, inside the label's own padding.
      expect(screen - label, lessThanOrEqualTo(20));
    });

    test('markers move to the right edge only for right-aligned text', () {
      AppearanceScope scope(TextAlign align) => AppearanceScope(
        labelFontSize: 28,
        labelAlign: align,
        accentAvailable: false,
        terminalPrompt: false,
        animate: false,
        child: const SizedBox.shrink(),
      );
      expect(scope(TextAlign.left).markersOnRight, isFalse);
      expect(scope(TextAlign.center).markersOnRight, isFalse);
      expect(scope(TextAlign.right).markersOnRight, isTrue);
    });
  });
}
