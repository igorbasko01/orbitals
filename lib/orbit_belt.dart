import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:orbitals/orbiter.dart';

class OrbitBelt extends PositionComponent {
  OrbitBelt({
    required this.radius,
    required this.angularSpeed,
    required this.maxSlots,
  }) : super(anchor: Anchor.center);

  final double radius;
  final double angularSpeed;
  final int maxSlots;

  /// Adds an orbiter to the next available slot on the belt.
  /// Returns true if successful, false if the belt is full.
  bool addOrbiter(Orbiter orbiter) {
    if (children.length >= maxSlots) {
      return false;
    }

    // Distribute orbiters evenly based on the total number of slots
    final slotAngle = (children.length / maxSlots) * 2 * math.pi;

    orbiter.position = Vector2(
      math.cos(slotAngle) * radius,
      math.sin(slotAngle) * radius,
    );

    add(orbiter);
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Rotate the entire belt. All children (orbiters) will rotate with it.
    angle += angularSpeed * dt;
  }
}
