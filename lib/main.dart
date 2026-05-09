
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:orbitals/orbitals_game.dart';

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

  @override
  void initState() {
    super.initState();
    _game = OrbitalsGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ORBITALS',
                    style: TextStyle(
                      color: Color(0xFFE8F1FF),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ValueListenableBuilder<double>(
                    valueListenable: _game.zoomLevel,
                    builder: (context, zoom, child) {
                      return Text(
                        'ZOOM: ${zoom.toStringAsFixed(2)}x',
                        style: TextStyle(
                          color: const Color(0xFFE8F1FF).withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Middle Section: Game with 1:1 Aspect Ratio
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE8F1FF).withValues(alpha: 0.1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: GameWidget(game: _game),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Section: Menus
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Zoom Out Button
                  _MenuButton(
                    onPressed: () => _game.zoomOut(),
                    icon: Icons.remove,
                    label: 'OUT',
                  ),

                  // Reset Zoom Button
                  _MenuButton(
                    onPressed: () => _game.resetZoom(),
                    icon: Icons.zoom_out_map,
                    label: 'RESET',
                    isPrimary: true,
                  ),

                  // Zoom In Button
                  _MenuButton(
                    onPressed: () => _game.zoomIn(),
                    icon: Icons.add,
                    label: 'IN',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _MenuButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF1A237E) : const Color(0xFF283593).withValues(alpha: 0.5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

