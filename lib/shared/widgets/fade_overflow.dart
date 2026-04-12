import 'package:flutter/material.dart';

class FadeOverflow extends StatelessWidget {
  const FadeOverflow({required this.child, this.size = 24.0, super.key});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, size / bounds.height, 1 - size / bounds.height, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
