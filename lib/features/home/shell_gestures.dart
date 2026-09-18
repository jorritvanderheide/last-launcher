import 'dart:ui' show Offset;

/// The gesture rules of the launcher shell, as pure decisions: what a drag
/// becomes, where it follows the finger to and where it settles. The shell
/// keeps the pointer state and animations and applies these.
///
/// Directions follow the shell's fractions: travel is positive when the
/// finger moves left (towards the right panel) or up (opening the drawer).

/// How far a finger moves before a touch counts as a drag.
const dragStartThreshold = 20.0;

/// A flick at least this fast (px/s) settles a drag even when it's short.
const swipeVelocityThreshold = 300.0;

/// A drag covering this fraction of the screen settles on the next slot.
const snapDeltaFraction = 0.05;

/// A second tap within this time and distance makes a double tap.
const doubleTapWindow = Duration(milliseconds: 300);
const doubleTapSlop = 40.0;

/// What a drag turns into once it's clear which way it goes.
enum DragStart {
  /// Nothing yet: too short, or a direction nothing moves in.
  none,

  /// Swiping between home and the side panels.
  page,

  /// Opening or closing the app drawer.
  sheet,

  /// Pulling down on home, which opens quick settings.
  quickSettings,
}

/// What a drag of [dx], [dy] becomes, given where the launcher is.
DragStart classifyDrag({
  required double dx,
  required double dy,
  required bool hasLeft,
  required bool hasRight,
  required double pageFraction,
  required bool onHomePage,
  required bool drawerOpen,
  required bool listWasAtTop,
  required bool reorderingHome,
  required bool reorderingTasks,
}) {
  final absDx = dx.abs();
  final absDy = dy.abs();
  if (absDx < dragStartThreshold && absDy < dragStartThreshold) {
    return DragStart.none;
  }

  if (absDx > absDy &&
      !drawerOpen &&
      (hasLeft || hasRight) &&
      !reorderingHome &&
      !reorderingTasks) {
    // Only towards a side that has a panel and isn't already showing.
    if (dx > 0 && pageFraction >= (hasRight ? 1.0 : 0.0)) {
      return DragStart.none;
    }
    if (dx < 0 && pageFraction <= (hasLeft ? -1.0 : 0.0)) {
      return DragStart.none;
    }
    return DragStart.page;
  }

  if (absDy > absDx) {
    if (!onHomePage || reorderingHome) return DragStart.none;
    if (!drawerOpen) {
      return dy > 0 ? DragStart.sheet : DragStart.quickSettings;
    }
    // An open drawer only closes, and only from the top of its list, so
    // scrolling the list doesn't drag the drawer.
    if (dy > 0 || !listWasAtTop) return DragStart.none;
    return DragStart.sheet;
  }

  return DragStart.none;
}

/// The fraction under the finger for a drag that started at [start] and has
/// travelled [travel] over a screen [extent], not counting the distance it
/// took to start, kept within [lower]..[upper].
double followDrag({
  required double start,
  required double travel,
  required double extent,
  required double lower,
  required double upper,
}) {
  final threshold = travel >= 0 ? dragStartThreshold : -dragStartThreshold;
  return (start + (travel - threshold) / extent).clamp(lower, upper);
}

/// Where a page drag settles when released: one slot on from [start] when
/// it went far or fast enough that way, bounded by the configured sides,
/// else back where it started.
double pageSnapTarget({
  required double start,
  required double delta,
  required double velocity,
  required double lower,
  required double upper,
}) {
  if (delta > snapDeltaFraction || velocity > swipeVelocityThreshold) {
    return (start + 1).clamp(lower, upper);
  }
  if (delta < -snapDeltaFraction || velocity < -swipeVelocityThreshold) {
    return (start - 1).clamp(lower, upper);
  }
  return start;
}

enum SheetSettle { open, close, back }

/// Where a drawer drag settles: open or closed when it went far or fast
/// enough that way, else back where it started.
SheetSettle sheetSnap({
  required double start,
  required double fraction,
  required double velocity,
}) {
  if (fraction > start + snapDeltaFraction ||
      velocity > swipeVelocityThreshold) {
    return SheetSettle.open;
  }
  if (fraction < start - snapDeltaFraction ||
      velocity < -swipeVelocityThreshold) {
    return SheetSettle.close;
  }
  return SheetSettle.back;
}

/// Whether a tap at [position] and [now] completes a double tap with the
/// one before it.
bool isDoubleTap({
  required DateTime? lastTime,
  required Offset? lastPosition,
  required DateTime now,
  required Offset position,
}) =>
    lastTime != null &&
    lastPosition != null &&
    (position - lastPosition).distance < doubleTapSlop &&
    now.difference(lastTime) < doubleTapWindow;
