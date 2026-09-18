import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/home/screens/launcher_shell.dart';

double _snap(double start, {double delta = 0, double velocity = 0}) =>
    pageSnapTarget(
      start: start,
      delta: delta,
      velocity: velocity,
      lower: -1,
      upper: 1,
    );

void main() {
  group('pageSnapTarget', () {
    test('a short, slow drag settles back where it started', () {
      expect(_snap(0, delta: 0.02), 0);
      expect(_snap(-1, delta: -0.02), -1);
    });

    test('a long enough drag moves one slot that way', () {
      expect(_snap(0, delta: 0.2), 1);
      expect(_snap(0, delta: -0.2), -1);
      expect(_snap(-1, delta: 0.2), 0);
    });

    test('a fast flick counts even when short', () {
      expect(_snap(0, velocity: 800), 1);
      expect(_snap(0, velocity: -800), -1);
    });

    test('never past a side that has no module', () {
      expect(
        pageSnapTarget(start: 0, delta: 0.5, velocity: 0, lower: -1, upper: 0),
        0,
      );
    });
  });
}
