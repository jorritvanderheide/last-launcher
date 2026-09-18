import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/shared/data/app_channel.dart';

const _channel = MethodChannel('nl.bw20.last_launcher/apps');

void _answer(Object? Function(MethodCall call) handler) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async => handler(call));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null),
  );

  test('reads the accent tones as colours', () async {
    _answer(
      (call) => {
        'onDark': 0xFFB0F2B0,
        'onLight': 0xFF1B5E20,
        'tint': 0xFF4CAF50,
      },
    );
    final accent = await AppChannel().getAccentColors();
    expect(accent?.onDark, const Color(0xFFB0F2B0));
    expect(accent?.onLight, const Color(0xFF1B5E20));
    expect(accent?.tint, const Color(0xFF4CAF50));
  });

  test('no accent before Android 12', () async {
    _answer((call) => null);
    expect(await AppChannel().getAccentColors(), isNull);
  });

  test('the same accent read twice compares equal', () async {
    _answer((call) => {'onDark': 1, 'onLight': 2, 'tint': 3});
    final channel = AppChannel();
    expect(await channel.getAccentColors(), await channel.getAccentColors());
  });
}
