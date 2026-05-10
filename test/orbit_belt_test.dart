import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbitals/orbit_belt.dart';
import 'package:orbitals/orbiter.dart';

void main() {
  group('OrbitBelt Tests', () {
    test('maxSlots calculation is correct', () {
      // Radius: 50, OrbiterRadius: 5.0, Spacing: 1.0 (touching)
      // Circumference = 2 * pi * 50 = 314.159
      // Diameter = 10
      // MaxSlots = floor(314.159 / 10) = 31
      final belt = OrbitBelt(
        radius: 50,
        angularSpeed: 1.0,
        maxOrbiterRadius: 5.0,
        spacingFactor: 1.0,
      );
      expect(belt.maxSlots, equals(31));
    });

    test('addOrbiter handles capacity correctly', () {
      final belt = OrbitBelt(
        radius: 20,
        angularSpeed: 1.0,
        maxOrbiterRadius: 5.0, // Circumference ~125, Diameter 10. Max slots: floor(125/11) ~ 11
        spacingFactor: 1.1,
      );
      
      final slots = belt.maxSlots;

      // Fill the belt
      for (int i = 0; i < slots; i++) {
        final success = belt.addOrbiter(Orbiter(radius: 2, color: Colors.red));
        expect(success, isTrue, reason: 'Failed to add orbiter at slot $i');
      }

      // Try adding one more
      final success = belt.addOrbiter(Orbiter(radius: 2, color: Colors.red));
      expect(success, isFalse, reason: 'Should not allow adding orbiter when full');
    });

    testWithGame<FlameGame>(
      'addOrbiter sets correct relative position',
      () => FlameGame(),
      (FlameGame game) async {
        final belt = OrbitBelt(
          radius: 100,
          angularSpeed: 1.0,
          maxOrbiterRadius: 10,
          spacingFactor: 1.0,
        );
        await game.add(belt);
        await game.ready();

        final orbiter = Orbiter(radius: 5, color: Colors.blue);
        belt.addOrbiter(orbiter);
        await game.ready(); // Wait for orbiter to be mounted

        // Slot 0 should be at angle 0.0 (x: radius, y: 0)
        expect(orbiter.position.x, closeTo(100.0, 0.01));
        expect(orbiter.position.y, closeTo(0.0, 0.01));

        final orbiter2 = Orbiter(radius: 5, color: Colors.green);
        belt.addOrbiter(orbiter2);
        await game.ready(); // Wait for orbiter2 to be mounted

        // Slot 1 angle: (1 / maxSlots) * 2 * pi
        // maxSlots for r=100, or=10 is floor(628.3 / 20) = 31
        final expectedAngle = (1 / 31) * 2 * math.pi;
        final expectedX = math.cos(expectedAngle) * 100.0;
        final expectedY = math.sin(expectedAngle) * 100.0;

        expect(orbiter2.position.x, closeTo(expectedX, 0.01));
        expect(orbiter2.position.y, closeTo(expectedY, 0.01));
      },
    );
  });
}
