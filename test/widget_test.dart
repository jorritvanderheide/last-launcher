import 'package:flutter_test/flutter_test.dart';

import 'package:last_launcher/main.dart';

void main() {
  testWidgets('app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LastLauncherApp());
    expect(find.text('Last Launcher'), findsOneWidget);
  });
}
