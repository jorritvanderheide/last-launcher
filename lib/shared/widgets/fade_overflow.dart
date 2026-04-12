import 'package:flutter/material.dart';

class FadeOverflow extends StatelessWidget {
  const FadeOverflow({required this.child, this.size = 24.0, super.key});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        final fadeSize = size.clamp(0.0, bounds.height / 2);
        final topStop = bounds.height > 0 ? fadeSize / bounds.height : 0.0;
        final bottomStop = 1.0 - topStop;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, topStop, bottomStop, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
