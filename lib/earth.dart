import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/procedural_planet_surface.dart';

class Earth extends CircleComponent {
  Earth({required double radius, required Anchor anchor})
    : super(radius: radius, anchor: anchor);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(
      ProceduralPlanetSurface(
        waterColor: const Color.fromARGB(255, 20, 114, 255),
        landColor: const Color(0xFF388E3C),
        rotationSpeed: 0.5,
      )..priority = 1,
    );

    // add(CloudLayer()..priority = 2);
  }
}
