import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Orbiter extends CircleComponent {
  Orbiter({
    required super.radius,
    required Color color,
    super.position,
  }) : super(
         anchor: Anchor.center,
         paint: Paint()..color = color,
       );
}
