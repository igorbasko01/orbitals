import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/earth.dart';

void main() {
  runApp(GameWidget(game: OrbitalsGame()));
}

class OrbitalsGame extends FlameGame {
  late final Earth _earth;
  late final List<Orbiter> _orbiters;
  late final TextComponent _title;

  @override
  Color backgroundColor() => const Color(0xFF050816);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _earth = Earth(radius: 42, anchor: Anchor.center);

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

    _title = TextComponent(
      text: 'Orbitals',
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE8F1FF),
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
        ),
      ),
    );

    // await add(_core);
    await add(_earth);
    await addAll(_orbiters);
    await add(_title);
    _layoutScene();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (!isLoaded) {
      return;
    }

    _layoutScene();
  }

  void _layoutScene() {
    final center = size / 2;
    _earth.position = center;
    _title.position = Vector2(size.x / 2, 24);

    for (final orbiter in _orbiters) {
      orbiter.setCenter(center);
    }
  }
}

class CorePulse extends CircleComponent {
  CorePulse()
    : super(
        radius: 42,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFF7FDBFF),
      );

  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    final scaleFactor = 0.92 + math.sin(_elapsed * 2.4) * 0.08;
    scale = Vector2.all(scaleFactor);

    final shimmer = 160 + (math.sin(_elapsed * 3.2) * 60).round();
    paint.color = Color.fromARGB(255, 125, 219, shimmer.clamp(0, 255));
  }
}

class Orbiter extends CircleComponent {
  Orbiter({
    required this.orbitRadius,
    required this.angularSpeed,
    required this.angle,
    required double radius,
    required Color color,
  }) : super(
         radius: radius,
         anchor: Anchor.center,
         paint: Paint()..color = color,
       );

  final double orbitRadius;
  final double angularSpeed;
  double angle;
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
