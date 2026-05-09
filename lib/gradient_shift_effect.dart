import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class GradientShiftEffect extends ComponentEffect<CircleComponent> {
  final List<Color> colors;
  final List<double> stops;

  GradientShiftEffect(this.colors, this.stops, EffectController controller)
    : super(controller);

  @override
  void apply(double progress) {
    final radius = target.radius;
    final offset = (progress * 2.0) - 1.0;

    target.paint.shader =
        LinearGradient(
          begin: Alignment(offset - 1.0, 0),
          end: Alignment(offset + 1.0, 0),
          colors: colors,
          stops: stops,
          tileMode: TileMode.mirror,
        ).createShader(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        );
  }
}
