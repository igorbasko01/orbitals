import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Orbiter extends CircleComponent {
  Orbiter({
    required double radius,
    required Color color,
    Vector2? position,
  }) : super(
         radius: radius,
         anchor: Anchor.center,
         paint: Paint()..color = color,
         position: position,
       );
}
