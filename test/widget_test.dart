import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app placeholder test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Last Launcher'))),
      ),
    );
    expect(find.text('Last Launcher'), findsOneWidget);
  });
}
