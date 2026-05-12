
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/orbitals_game.dart';
import 'package:orbitals/widgets/base_menu_page.dart';
import 'package:orbitals/widgets/main_menu_widgets.dart';

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
  
  // The persistent map Flame uses to find builders
  final Map<String, OverlayWidgetBuilder<OrbitalsGame>> _builders = {};
  
  // Navigation History
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _game = OrbitalsGame();
    
    // Bootstrap the first page
    _registerPage(MainMenuPage());
  }

  void _registerPage(BaseMenuPage page) {
    _builders[page.name] = (context, game) => page.build(
      context,
      game,
      _popOverlay,
      _pushOverlay,
    );
    if (!_history.contains(page.name)) {
      _history.add(page.name);
    }
  }

  void _pushOverlay(BaseMenuPage page) {
    if (_history.isNotEmpty && _history.last == page.name) return;
    
    // Store the current top so we can remove it after the frame
    final previousOverlay = _history.isNotEmpty ? _history.last : null;

    setState(() {
      // 1. Update our map so the NEXT build of GameWidget includes this builder
      _builders[page.name] = (context, game) => page.build(
        context,
        game,
        _popOverlay,
        _pushOverlay,
      );
      _history.add(page.name);
    });

    // 2. Wait until the frame is rendered and GameWidget has received the new map
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (previousOverlay != null) {
          _game.overlays.remove(previousOverlay);
        }
        _game.overlays.add(page.name);
      }
    });
  }

  void _popOverlay() {
    if (_history.length > 1) {
      setState(() {
        final poppedName = _history.removeLast();
        _game.overlays.remove(poppedName);
        
        // Memory management: only remove if not used elsewhere
        if (!_history.contains(poppedName)) {
          _builders.remove(poppedName);
        }
        
        _game.overlays.add(_history.last);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: GameWidget<OrbitalsGame>(
          game: _game,
          overlayBuilderMap: _builders,
          initialActiveOverlays: [_history.first],
        ),
      ),
    );
  }
}
