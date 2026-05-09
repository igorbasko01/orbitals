import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Orbiter extends CircleComponent {
  Orbiter({
    required this.orbitRadius,
    required this.angularSpeed,
    required double angle,
    required double radius,
    required Color color,
  }) : super(
         radius: radius,
         angle: angle,
         anchor: Anchor.center,
         paint: Paint()..color = color,
       );

  final double orbitRadius;
  final double angularSpeed;
  Vector2 _center = Vector2.zero();

  void setCenter(Vector2 center) {
    _center = center;
    position = _positionForCurrentAngle();
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += angularSpeed * dt;
    position = _positionForCurrentAngle();
  }

  Vector2 _positionForCurrentAngle() {
    return Vector2(
      _center.x + math.cos(angle) * orbitRadius,
      _center.y + math.sin(angle) * orbitRadius,
    );
  }
}
