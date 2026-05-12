
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/orbitals_game.dart';
import 'package:orbitals/widgets/main_menu_widgets.dart';
import 'package:orbitals/widgets/zoom_widgets.dart';

void main() {
  runApp(const OrbitalsApp());
}

class OrbitalsApp extends StatelessWidget {
  const OrbitalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const OrbitalsMainScreen(),
    );
  }
}

class OrbitalsMainScreen extends StatefulWidget {
  const OrbitalsMainScreen({super.key});

  @override
  State<OrbitalsMainScreen> createState() => _OrbitalsMainScreenState();
}

class OverlayNames {
  static const String main = 'main';
  static const String zoom = 'zoom';
}

class _OrbitalsMainScreenState extends State<OrbitalsMainScreen> {
  late final OrbitalsGame _game;
  final List<String> _history = [OverlayNames.main];

  @override
  void initState() {
    super.initState();
    _game = OrbitalsGame();
  }

  void _pushOverlay(String name) {
    if (_history.last == name) return;
    _game.overlays.remove(_history.last);
    _history.add(name);
    _game.overlays.add(name);
  }

  void _popOverlay() {
    if (_history.length > 1) {
      _game.overlays.remove(_history.removeLast());
      _game.overlays.add(_history.last);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: GameWidget<OrbitalsGame>(
          game: _game,
          overlayBuilderMap: {
            OverlayNames.main: (context, game) => _OverlayLayout(
                  top: const MainHeader(),
                  bottom: MainControls(
                    onZoomPressed: () => _pushOverlay(OverlayNames.zoom),
                  ),
                ),
            OverlayNames.zoom: (context, game) => _OverlayLayout(
                  top: ZoomHeader(game: game),
                  bottom: ZoomControls(
                    game: game,
                    onBack: _popOverlay,
                  ),
                ),
          },
          initialActiveOverlays: const [OverlayNames.main],
        ),
      ),
    );
  }
}

/// A simple layout shared by all game overlays to keep top/bottom split
class _OverlayLayout extends StatelessWidget {
  final Widget top;
  final Widget bottom;

  const _OverlayLayout({
    required this.top,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          // Top HUD Section
          Container(
            height: 100,
            alignment: Alignment.center,
            child: top,
          ),

          // Transparent middle section (The Game is visible here)
          const Expanded(child: SizedBox.shrink()),

          // Bottom HUD Section
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: bottom,
          ),
        ],
      ),
    );
  }
}

