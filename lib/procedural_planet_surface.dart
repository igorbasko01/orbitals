import 'dart:ui';

import 'package:flame/components.dart';

class ProceduralPlanetSurface extends CircleComponent
    with ParentIsA<CircleComponent> {
  final Color waterColor;
  final Color landColor;
  final double rotationSpeed;

  FragmentShader? _shader;
  double _time = 0.0;

  ProceduralPlanetSurface({
    required this.waterColor,
    required this.landColor,
    this.rotationSpeed = 1.0,
  }) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    radius = parent.radius;
    position = parent.size / 2;

    final program = await FragmentProgram.fromAsset('shaders/planet.frag');
    _shader = program.fragmentShader();

    _initStaticUniforms();

    paint.shader = _shader;
  }

  void _initStaticUniforms() {
    if (_shader == null) return;

    _shader!.setFloat(0, size.x);
    _shader!.setFloat(1, size.y);

    _shader!.setFloat(3, waterColor.r);
    _shader!.setFloat(4, waterColor.g);
    _shader!.setFloat(5, waterColor.b);
    _shader!.setFloat(6, waterColor.a);

    _shader!.setFloat(7, landColor.r);
    _shader!.setFloat(8, landColor.g);
    _shader!.setFloat(9, landColor.b);
    _shader!.setFloat(10, landColor.a);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_shader == null) return;

    _time += dt * rotationSpeed;

    _shader!.setFloat(2, _time);
  }
}
