import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/shared/search_focus_controller.dart';

/// Mounts a field bound to a fresh controller. [autoKeyboard] is read through
/// a closure, as the real screens do, so tests can flip it mid-run.
Future<SearchFocusController> _mount(
  WidgetTester tester, {
  bool Function()? autoKeyboard,
  OverscrollPolicy policy = OverscrollPolicy.immediate,
}) async {
  final controller = SearchFocusController(
    autoKeyboard: autoKeyboard ?? () => true,
    overscrollPolicy: policy,
  );
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: TextField(focusNode: controller.node)),
    ),
  );
  return controller;
}

/// Runs the post-frame focus request and then the keyboard nudge behind it, so
/// no timer outlives the test.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(
    SearchFocusController.nudgeDelay + const Duration(milliseconds: 1),
  );
}

/// Opens the panel and lets the focus request land.
Future<void> _open(
  WidgetTester tester,
  SearchFocusController controller,
) async {
  controller.panelOpened();
  await _settle(tester);
}

void main() {
  testWidgets('opening the panel raises the keyboard', (tester) async {
    final controller = await _mount(tester);
    await _open(tester, controller);
    expect(controller.hasFocus, isTrue);
  });

  testWidgets(
    'opening the panel leaves focus alone when auto-keyboard is off',
    (tester) async {
      final controller = await _mount(tester, autoKeyboard: () => false);
      await _open(tester, controller);
      expect(controller.hasFocus, isFalse);
    },
  );

  testWidgets('scrolling down dismisses, returning to the top restores', (
    tester,
  ) async {
    final controller = await _mount(tester);
    await _open(tester, controller);

    controller.scrolled(SearchFocusController.dismissOffset + 1);
    await tester.pump();
    expect(controller.hasFocus, isFalse);

    controller.scrolled(0);
    await tester.pump();
    expect(controller.hasFocus, isTrue);
  });

  testWidgets('scrolling within the threshold keeps the keyboard', (
    tester,
  ) async {
    final controller = await _mount(tester);
    await _open(tester, controller);

    controller.scrolled(SearchFocusController.dismissOffset);
    await tester.pump();
    expect(controller.hasFocus, isTrue);
  });

  testWidgets('a closed panel never grabs focus', (tester) async {
    final controller = await _mount(tester);
    await _open(tester, controller);
    controller.panelClosed();
    await tester.pump();

    // Closing a panel resets its list, which reports a scroll back to the top.
    controller.scrolled(0);
    await tester.pump();
    expect(controller.hasFocus, isFalse);
  });

  testWidgets('resuming only re-requests while the panel is open', (
    tester,
  ) async {
    final controller = await _mount(tester);
    controller.appResumed();
    await _settle(tester);
    expect(controller.hasFocus, isFalse);

    await _open(tester, controller);
    controller.node.unfocus();
    await tester.pump();

    controller.appResumed();
    await _settle(tester);
    expect(controller.hasFocus, isTrue);
  });

  testWidgets('immediate policy dismisses on any downward overscroll', (
    tester,
  ) async {
    final controller = await _mount(tester);
    await _open(tester, controller);

    controller.overscrolled(-5);
    await tester.pump();
    expect(controller.hasFocus, isTrue);

    controller.overscrolled(1);
    await tester.pump();
    expect(controller.hasFocus, isFalse);
  });

  testWidgets('cumulative policy needs the threshold before dismissing', (
    tester,
  ) async {
    final controller = await _mount(
      tester,
      policy: OverscrollPolicy.cumulative,
    );
    await _open(tester, controller);

    const step = SearchFocusController.overscrollThreshold / 2;
    controller.overscrolled(step);
    await tester.pump();
    expect(controller.hasFocus, isTrue);

    controller.overscrolled(step + 1);
    await tester.pump();
    expect(controller.hasFocus, isFalse);

    // Overscrolling back up the same distance brings it back.
    controller.overscrolled(-(SearchFocusController.overscrollThreshold + 1));
    await tester.pump();
    expect(controller.hasFocus, isTrue);
  });

  testWidgets('cumulative policy forgets overscroll between gestures', (
    tester,
  ) async {
    final controller = await _mount(
      tester,
      policy: OverscrollPolicy.cumulative,
    );
    await _open(tester, controller);

    const step = SearchFocusController.overscrollThreshold / 2 + 1;
    controller.overscrolled(step);
    controller.scrollStarted();
    controller.overscrolled(step);
    await tester.pump();
    expect(controller.hasFocus, isTrue);
  });
}
