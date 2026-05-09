import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/gradient_shift_effect.dart';

class CloudLayer extends CircleComponent with ParentIsA<CircleComponent> {
  CloudLayer() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    radius = parent.radius * 1.02;
    position = parent.size / 2;

    final cloudColors = [
      Colors.white.withAlpha(204),
      Colors.transparent,
      Colors.white.withAlpha(102),
      Colors.transparent,
      Colors.white.withAlpha(204),
    ];
    final cloudStops = [0.0, 0.3, 0.6, 0.8, 1.0];

    add(
      GradientShiftEffect(
        cloudColors,
        cloudStops,
        EffectController(duration: 10, infinite: true),
      ),
    );
  }
}
