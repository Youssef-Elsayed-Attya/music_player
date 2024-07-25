import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateX, translateY }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final double start;
  final double end;
  final Axis direction;

  FadeAnimation({
    required this.delay,
    required this.child,
    this.start = -30.0,
    this.end = 0.0,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(AniProps.opacity, 0.0.tweenTo(1.0), duration: 500.milliseconds)
      ..tween(
        direction == Axis.vertical ? AniProps.translateY : AniProps.translateX,
        start.tweenTo(end),
        duration: 500.milliseconds,
        curve: Curves.easeOut,
      );

    return PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(
            offset: direction == Axis.vertical
                ? Offset(0, value.get(AniProps.translateY))
                : Offset(value.get(AniProps.translateX), 0),  // Horizontal or vertical movement
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
