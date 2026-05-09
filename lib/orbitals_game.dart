import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/earth.dart';
import 'package:orbitals/orbiter.dart';

class OrbitalsGame extends FlameGame {
  late final Earth _earth;
  late final List<Orbiter> _orbiters;

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

    _orbiters = [
      Orbiter(
        orbitRadius: 90,
        angularSpeed: 1.1,
        angle: 0.2,
        radius: 10,
        color: const Color(0xFF80CBC4),
      ),
      Orbiter(
        orbitRadius: 140,
        angularSpeed: -0.75,
        angle: 2.2,
        radius: 14,
        color: const Color(0xFFFFAB91),
      ),
      Orbiter(
        orbitRadius: 190,
        angularSpeed: 0.45,
        angle: 4.5,
        radius: 18,
        color: const Color(0xFFFFF59D),
      ),
    ];

    for (final orbiter in _orbiters) {
      orbiter.setCenter(Vector2.zero());
    }

    await world.add(_earth);
    await world.addAll(_orbiters);
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
