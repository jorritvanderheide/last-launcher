import 'dart:math';

import 'package:flutter/material.dart';
import 'package:last_launcher/shared/widgets/appearance_scope.dart';

/// Provides the current scanline band position to descendants.
class ScanlineScope extends InheritedWidget {
  const ScanlineScope({
    required this.active,
    required this.bandY,
    required this.bandHeight,
    required super.child,
    super.key,
  });

  /// Whether scanlines are drawn at all. The scope is always present so that
  /// switching them on and off doesn't rebuild what's underneath.
  final bool active;
  final double bandY;
  final double bandHeight;

  static ScanlineScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScanlineScope>();
  }

  @override
  bool updateShouldNotify(ScanlineScope oldWidget) =>
      active != oldWidget.active || (bandY ~/ 20) != (oldWidget.bandY ~/ 20);
}

/// Draws CRT-style scanlines over [child], with a band sweeping down the
/// screen while animations are on.
///
/// [strength] scales the lines: 0 draws nothing, 1 is the original look.
/// Lines are only drawn in a dark theme, since they were designed for one.
class ScanlineOverlay extends StatefulWidget {
  const ScanlineOverlay({
    required this.strength,
    required this.child,
    super.key,
  });

  final double strength;
  final Widget child;

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _active = false;
  bool _sweep = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(ScanlineOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    _active =
        widget.strength > 0 && Theme.of(context).brightness == Brightness.dark;
    _sweep = _active && AppearanceScope.of(context).animate;
    if (!_sweep && _controller.isAnimating) {
      _controller.stop();
    } else if (_sweep && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        final bandHeight = screenHeight * 0.08;
        // Quantize to ~30fps worth of steps.
        final steps = (screenHeight / 2).round();
        final quantized = steps > 0
            ? (_controller.value * steps).round() / steps
            : _controller.value;
        final bandY = quantized * (screenHeight + bandHeight) - bandHeight;

        return ScanlineScope(
          active: _active,
          bandY: bandY,
          bandHeight: bandHeight,
          child: Stack(
            children: [
              child!,
              if (_active)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _ScanlinePainter(
                        animationValue: quantized,
                        color: color,
                        strength: widget.strength,
                        sweep: _sweep,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter({
    required this.animationValue,
    required this.color,
    required this.strength,
    required this.sweep,
  });

  final double animationValue;
  final Color color;
  final double strength;
  final bool sweep;

  int _alpha(int base) => (base * strength).round().clamp(0, 255);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withAlpha(_alpha(0x14))
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    if (!sweep) return;
    final bandHeight = size.height * 0.08;
    final bandY = animationValue * (size.height + bandHeight) - bandHeight;
    final bandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withAlpha(0),
          color.withAlpha(_alpha(0x0C)),
          color.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, bandY, size.width, bandHeight));

    canvas.drawRect(Rect.fromLTWH(0, bandY, size.width, bandHeight), bandPaint);
  }

  @override
  bool shouldRepaint(_ScanlinePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.color != color ||
      oldDelegate.strength != strength ||
      oldDelegate.sweep != sweep;
}

/// Glitch characters used for the text corruption effect.
const _glitchChars = '░▒▓█▀▄▌▐│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬';
final _random = Random();

String glitchText(String text, double intensity) {
  if (intensity <= 0) return text;
  final chars = text.characters.toList();
  for (var i = 0; i < chars.length; i++) {
    if (_random.nextDouble() < intensity) {
      chars[i] = _glitchChars[_random.nextInt(_glitchChars.length)];
    }
  }
  return chars.join();
}
