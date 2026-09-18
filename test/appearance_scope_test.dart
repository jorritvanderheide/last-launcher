import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
