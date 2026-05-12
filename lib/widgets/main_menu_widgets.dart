import 'package:flutter/material.dart';
import '../orbitals_game.dart';
import 'base_menu_page.dart';
import 'menu_button.dart';
import 'zoom_widgets.dart';

class MainMenuPage extends BaseMenuPage {
  @override
  Widget build(
    BuildContext context,
    OrbitalsGame game,
    VoidCallback pop,
    PushCallback push,
  ) {
    return HUDLayout(
      top: const _MainHeader(),
      bottom: _MainControls(
        onZoomPressed: () => push(ZoomMenuPage()),
      ),
    );
  }
}

class _MainHeader extends StatelessWidget {
  const _MainHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFE8F1FF), Color(0xFF80CBC4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'ORBITALS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fiber_manual_record, size: 8, color: Color(0xFF4CAF50)),
              SizedBox(width: 6),
              Text(
                'SYSTEM ACTIVE',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MainControls extends StatelessWidget {
  final VoidCallback onZoomPressed;

  const _MainControls({
    required this.onZoomPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MenuButton(
          onPressed: onZoomPressed,
          icon: Icons.zoom_in,
          label: 'ZOOM',
          isPrimary: true,
        ),
      ],
    );
  }
}
