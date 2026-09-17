import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// How overscrolling a list affects the keyboard.
enum OverscrollPolicy {
  /// Any downward overscroll dismisses the keyboard. Used by the app drawer.
  immediate,

  /// Overscroll accumulates: [SearchFocusController.overscrollThreshold] of
  /// downward travel dismisses the keyboard and the same amount upward brings
  /// it back, with the running total reset at the start of every scroll. Used
  /// by the task panel.
  cumulative,
}

/// Owns a search field's [FocusNode] and the policy for when the soft keyboard
/// should be up.
///
/// The app drawer and the task panel both drive this, so the rules live in one
/// place instead of being restated (and drifting) per screen. The only
/// deliberate difference between the two is [overscrollPolicy].
///
/// Callers don't focus or unfocus [node] themselves: they report what happened
/// ([panelOpened], [scrolled], [overscrolled], ...) and the policy decides.
class SearchFocusController {
  SearchFocusController({
    required this.autoKeyboard,
    this.overscrollPolicy = OverscrollPolicy.immediate,
  });

  /// Whether the keyboard may open on its own. Read at every decision point so
  /// that flipping the setting takes effect without rebuilding the controller.
  final bool Function() autoKeyboard;

  final OverscrollPolicy overscrollPolicy;

  /// Scroll offset past which the keyboard is dismissed.
  static const dismissOffset = 20.0;

  /// Accumulated overscroll that toggles the keyboard under
  /// [OverscrollPolicy.cumulative].
  static const overscrollThreshold = 20.0;

  /// How long to wait before re-asking the platform for the keyboard.
  static const nudgeDelay = Duration(milliseconds: 300);

  final FocusNode node = FocusNode();

  bool _panelOpen = false;
  double _overscrollTotal = 0;
  Timer? _nudgeTimer;
  bool _disposed = false;

  bool get hasFocus => node.hasFocus;

  /// Whether the panel owning the field is showing. Nothing auto-focuses while
  /// this is false, so an off-screen panel can't hold the keyboard open.
  bool get panelOpen => _panelOpen;

  /// The panel holding the search field became visible.
  void panelOpened() {
    _panelOpen = true;
    _overscrollTotal = 0;
    if (autoKeyboard()) requestKeyboard();
  }

  /// The panel was dismissed.
  void panelClosed() {
    _panelOpen = false;
    _overscrollTotal = 0;
    _cancelNudge();
    node.unfocus();
  }

  /// The app returned to the foreground. A fast swipe-up after returning to
  /// the launcher can be processed before Android marks the window as resumed,
  /// in which case the IME ignored the original focus request.
  void appResumed() {
    if (!_panelOpen || !autoKeyboard()) return;
    requestKeyboard();
  }

  /// Focus the field and make sure the keyboard actually comes up.
  void requestKeyboard() {
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((_) {
      if (_disposed || !_panelOpen) return;
      node.requestFocus();
      _scheduleNudge();
    });
    // A post-frame callback does not schedule a frame by itself. Requests that
    // arrive with a build already in flight would run anyway, but one coming
    // from a lifecycle change has no frame behind it and would otherwise sit
    // there until something else happened to draw.
    binding.ensureVisualUpdate();
  }

  /// The list scrolled to [offset]: scrolling down dismisses the keyboard,
  /// coming back to the top brings it back.
  void scrolled(double offset) {
    if (offset > dismissOffset) {
      if (node.hasFocus) node.unfocus();
    } else if (offset <= 0) {
      _focusIfAllowed();
    }
  }

  /// A new scroll gesture started. Only meaningful under
  /// [OverscrollPolicy.cumulative].
  void scrollStarted() => _overscrollTotal = 0;

  /// The list overscrolled by [delta] (positive = past the bottom).
  void overscrolled(double delta) {
    switch (overscrollPolicy) {
      case OverscrollPolicy.immediate:
        if (delta > 0 && node.hasFocus) node.unfocus();
      case OverscrollPolicy.cumulative:
        _overscrollTotal += delta;
        if (_overscrollTotal > overscrollThreshold && node.hasFocus) {
          node.unfocus();
          _overscrollTotal = 0;
        } else if (_overscrollTotal < -overscrollThreshold) {
          _focusIfAllowed();
          _overscrollTotal = 0;
        }
    }
  }

  /// The user submitted the field and the panel stays open.
  void submitted() => node.requestFocus();

  void dispose() {
    _disposed = true;
    _cancelNudge();
    node.dispose();
  }

  void _focusIfAllowed() {
    if (!_panelOpen || node.hasFocus || !autoKeyboard()) return;
    node.requestFocus();
  }

  /// After an app switch or device unlock the platform sometimes grants focus
  /// but suppresses the keyboard, so ask a second time.
  ///
  /// Asking again is a no-op when the keyboard is already up or animating in,
  /// which is why this is a plain re-request and not an unfocus/refocus
  /// bounce: a bounce tears down a keyboard that was merely slow, which the
  /// user sees as the keyboard opening, closing and opening again.
  ///
  /// Deliberately does not consult `MediaQuery.viewInsets` to decide whether
  /// the keyboard made it. Those insets lag a focus request by a full IME show
  /// animation, so a keyboard on its way up still reads as absent.
  void _scheduleNudge() {
    _cancelNudge();
    _nudgeTimer = Timer(nudgeDelay, () {
      if (_disposed || !_panelOpen || !node.hasFocus) return;
      unawaited(SystemChannels.textInput.invokeMethod('TextInput.show'));
    });
  }

  void _cancelNudge() {
    _nudgeTimer?.cancel();
    _nudgeTimer = null;
  }
}
