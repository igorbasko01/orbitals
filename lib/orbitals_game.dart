import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/earth.dart';
import 'package:orbitals/orbiter.dart';
import 'package:orbitals/orbit_belt.dart';

class OrbitalsGame extends FlameGame {
  late final Earth _earth;

  /// Notifies listeners when the zoom level changes
  final ValueNotifier<double> zoomLevel = ValueNotifier(1.0);

  @override
  Color backgroundColor() => Colors.transparent; // Managed by Flutter Scaffold

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final world = World();
    await add(world);

    camera = CameraComponent(world: world);
    await add(camera);

    // Sync camera zoom with the notifier
    zoomLevel.addListener(_onZoomChanged);

    _earth = Earth(radius: 42, anchor: Anchor.center);
    _earth.position = Vector2.zero();
    await world.add(_earth);

    // Create three belts with different speeds and radii
    final belts = [
      OrbitBelt(radius: 50, angularSpeed: 1.1, maxOrbiterRadius: 5.0),
      OrbitBelt(radius: 70, angularSpeed: -0.75, maxOrbiterRadius: 5.0),
      OrbitBelt(radius: 90, angularSpeed: 0.45, maxOrbiterRadius: 5.0),
    ];

    // Add some initial orbiters to the belts
    final colors = [
      const Color(0xFF80CBC4),
      const Color(0xFFFFAB91),
      const Color(0xFFFFF59D),
    ];

    for (int i = 0; i < belts.length; i++) {
      final belt = belts[i];
      await world.add(belt);

      // Add one orbiter to each belt initially
      belt.addOrbiter(Orbiter(radius: 5, color: colors[i]));
    }
  }

  @override
  void onRemove() {
    zoomLevel.removeListener(_onZoomChanged);
    super.onRemove();
  }

  void _onZoomChanged() {
    camera.viewfinder.zoom = zoomLevel.value;
  }

  void resetZoom() {
    zoomLevel.value = 1.0;
  }

  void zoomIn() {
    _clampAndSetZoom(zoomLevel.value + 0.1);
  }

  void zoomOut() {
    _clampAndSetZoom(zoomLevel.value - 0.1);
  }

  void _clampAndSetZoom(double value) {
    zoomLevel.value = value.clamp(0.1, 1.0);
  }
}
