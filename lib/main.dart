
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/orbitals_game.dart';
import 'package:orbitals/widgets/base_menu_page.dart';
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

class _OrbitalsMainScreenState extends State<OrbitalsMainScreen> {
  late final OrbitalsGame _game;

  // The Declarative Menu Registry
  final List<BaseMenuPage> _menuPages = [
    MainMenuPage(),
    ZoomMenuPage(),
  ];

  // Initialize history using the registry (default to the first page's name)
  late final List<String> _history = [_menuPages.first.name];

  @override
  void initState() {
    super.initState();
    _game = OrbitalsGame();
  }

  void _pushOverlay<T extends BaseMenuPage>() {
    // Find the name of the target page by its Type
    final name = T.toString();
    
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

  /// Factory: Automatically builds the Flame overlay map from our page registry
  Map<String, Widget Function(BuildContext, OrbitalsGame)> _buildOverlayMap() {
    return {
      for (final page in _menuPages)
        page.name: (context, game) => page.build(
              context,
              game,
              _popOverlay,
              _pushOverlay,
            ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: GameWidget<OrbitalsGame>(
          game: _game,
          overlayBuilderMap: _buildOverlayMap(),
          initialActiveOverlays: [_menuPages.first.name],
        ),
      ),
    );
  }
}

