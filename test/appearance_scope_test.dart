import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';
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
        terminalPrompt: true,
        animate: false,
        child: SizedBox.shrink(),
      ),
    );
    expect(find.text(r'$ '), findsOneWidget);
  });
}
