
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/earth.dart';
import 'package:orbitals/orbiter.dart';

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

