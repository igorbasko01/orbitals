import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/gradient_shift_effect.dart';

class PlanetSurface extends CircleComponent with ParentIsA<CircleComponent> {
  final List<Color> surfaceColors;
  final List<double> colorStops;
  final double rotationDuration;

  PlanetSurface({
    required this.surfaceColors,
    required this.colorStops,
    this.rotationDuration = 15.0,
  }) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    radius = parent.radius;
    position = parent.size / 2;

    add(
      GradientShiftEffect(
        surfaceColors,
        colorStops,
        EffectController(duration: rotationDuration, infinite: true),
      ),
    );
  }
}
