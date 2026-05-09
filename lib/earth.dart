import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Earth extends CircleComponent {
  Earth({required double radius, required Anchor anchor})
    : super(
        radius: radius,
        anchor: anchor,
        paint: Paint()..color = const Color(0xFF1E88E5),
      );
}
