import 'dart:math';

import 'package:flutter/material.dart';

/// Provides the current scanline band Y position to descendants.
class ScanlineScope extends InheritedWidget {
  const ScanlineScope({
    required this.bandY,
    required this.bandHeight,
    required super.child,
    super.key,
  });

  final double bandY;
  final double bandHeight;

  static ScanlineScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScanlineScope>();
  }

  @override
  bool updateShouldNotify(ScanlineScope oldWidget) =>
      (bandY ~/ 20) != (oldWidget.bandY ~/ 20);
}

class ScanlineOverlay extends StatefulWidget {
  const ScanlineOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable && _controller.isAnimating) {
      _controller.stop();
    } else if (!disable && !_controller.isAnimating) {
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
          bandY: bandY,
          bandHeight: bandHeight,
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _ScanlinePainter(quantized)),
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
  _ScanlinePainter(this.animationValue);

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0x14FFFFFF)
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final bandHeight = size.height * 0.08;
    final bandY = animationValue * (size.height + bandHeight) - bandHeight;
    final bandPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x00FFFFFF), Color(0x0CFFFFFF), Color(0x00FFFFFF)],
      ).createShader(Rect.fromLTWH(0, bandY, size.width, bandHeight));

    canvas.drawRect(Rect.fromLTWH(0, bandY, size.width, bandHeight), bandPaint);
  }

  @override
  bool shouldRepaint(_ScanlinePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
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
