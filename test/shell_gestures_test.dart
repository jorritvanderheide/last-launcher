import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/home/shell_gestures.dart';

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

  group('classifyDrag', () {
    DragStart classify({
      double dx = 0,
      double dy = 0,
      bool hasLeft = true,
      bool hasRight = true,
      double pageFraction = 0,
      bool onHomePage = true,
      bool drawerOpen = false,
      bool listWasAtTop = true,
      bool reorderingHome = false,
      bool reorderingTasks = false,
    }) => classifyDrag(
      dx: dx,
      dy: dy,
      hasLeft: hasLeft,
      hasRight: hasRight,
      pageFraction: pageFraction,
      onHomePage: onHomePage,
      drawerOpen: drawerOpen,
      listWasAtTop: listWasAtTop,
      reorderingHome: reorderingHome,
      reorderingTasks: reorderingTasks,
    );

    test('a short move is not a drag yet', () {
      expect(classify(dx: 19, dy: 19), DragStart.none);
    });

    test('sideways swipes between pages', () {
      expect(classify(dx: 40), DragStart.page);
      expect(classify(dx: -40), DragStart.page);
    });

    test('not towards a side without a panel, or past the last one', () {
      expect(classify(dx: 40, hasRight: false), DragStart.none);
      expect(classify(dx: -40, hasLeft: false), DragStart.none);
      expect(classify(dx: 40, pageFraction: 1), DragStart.none);
      expect(classify(dx: 40, hasLeft: false, hasRight: false), DragStart.none);
    });

    test('no paging while reordering or with the drawer open', () {
      expect(classify(dx: 40, reorderingHome: true), DragStart.none);
      expect(classify(dx: 40, reorderingTasks: true), DragStart.none);
      expect(classify(dx: 40, drawerOpen: true), DragStart.none);
    });

    test('up opens the drawer, down pulls quick settings', () {
      expect(classify(dy: 40), DragStart.sheet);
      expect(classify(dy: -40), DragStart.quickSettings);
    });

    test('vertical drags only act on the home page', () {
      expect(classify(dy: 40, onHomePage: false), DragStart.none);
      expect(classify(dy: 40, reorderingHome: true), DragStart.none);
    });

    test('an open drawer closes from the top of its list only', () {
      expect(classify(dy: -40, drawerOpen: true), DragStart.sheet);
      expect(
        classify(dy: -40, drawerOpen: true, listWasAtTop: false),
        DragStart.none,
      );
      expect(classify(dy: 40, drawerOpen: true), DragStart.none);
    });

    test('the larger direction decides', () {
      expect(classify(dx: 50, dy: 30), DragStart.page);
      expect(classify(dx: 30, dy: 50), DragStart.sheet);
    });
  });

  group('followDrag', () {
    test('follows the finger, minus the distance it took to start', () {
      expect(
        followDrag(start: 0, travel: 120, extent: 1000, lower: -1, upper: 1),
        closeTo(0.1, 1e-9),
      );
      expect(
        followDrag(start: 0, travel: -120, extent: 1000, lower: -1, upper: 1),
        closeTo(-0.1, 1e-9),
      );
    });

    test('stays within its bounds', () {
      expect(
        followDrag(start: 0.8, travel: 900, extent: 1000, lower: 0, upper: 0.9),
        0.9,
      );
    });
  });

  group('sheetSnap', () {
    test('opens or closes when dragged far enough, else goes back', () {
      expect(sheetSnap(start: 0, fraction: 0.1, velocity: 0), SheetSettle.open);
      expect(
        sheetSnap(start: 0.9, fraction: 0.8, velocity: 0),
        SheetSettle.close,
      );
      expect(
        sheetSnap(start: 0.9, fraction: 0.88, velocity: 0),
        SheetSettle.back,
      );
    });

    test('a flick counts even when short', () {
      expect(
        sheetSnap(start: 0, fraction: 0.01, velocity: 800),
        SheetSettle.open,
      );
      expect(
        sheetSnap(start: 0.9, fraction: 0.89, velocity: -800),
        SheetSettle.close,
      );
    });
  });

  group('isDoubleTap', () {
    final first = DateTime(2026);
    bool tap(Duration after, Offset at) => isDoubleTap(
      lastTime: first,
      lastPosition: Offset.zero,
      now: first.add(after),
      position: at,
    );

    test('quick and close is a double tap', () {
      expect(
        tap(const Duration(milliseconds: 200), const Offset(10, 10)),
        true,
      );
    });

    test('too slow or too far is not', () {
      expect(tap(const Duration(milliseconds: 400), Offset.zero), false);
      expect(
        tap(const Duration(milliseconds: 100), const Offset(50, 0)),
        false,
      );
    });

    test('a first tap is not', () {
      expect(
        isDoubleTap(
          lastTime: null,
          lastPosition: null,
          now: first,
          position: Offset.zero,
        ),
        false,
      );
    });
  });
}
