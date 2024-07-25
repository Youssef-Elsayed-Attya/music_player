import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, scale }

class ScaleAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final double startScale;
  final double endScale;

  ScaleAnimation({
    required this.delay,
    required this.child,
    this.startScale = 0.0, // Start scaling from 0
    this.endScale = 1.0, // End scaling to full size
  });

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(AniProps.opacity, 0.0.tweenTo(1.0), duration: 500.milliseconds)
      ..tween(AniProps.scale, startScale.tweenTo(endScale),
          duration: 500.milliseconds, curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.scale(
            scale: value.get(AniProps.scale), // Scale transformation
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
