import 'package:flutter/material.dart';
import '../orbitals_game.dart';
import 'base_menu_page.dart';
import 'menu_button.dart';

class ZoomMenuPage extends BaseMenuPage {
  @override
  Widget build(
    BuildContext context,
    OrbitalsGame game,
    VoidCallback pop,
    PushCallback push,
  ) {
    return _OverlayLayout(
      top: _ZoomHeader(game: game),
      bottom: _ZoomControls(
        game: game,
        onBack: pop,
      ),
    );
  }
}

class _ZoomHeader extends StatelessWidget {
  final OrbitalsGame game;

  const _ZoomHeader({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.settings_overscan,
              size: 20,
              color: const Color(0xFFFFB74D).withValues(alpha: 0.8),
            ),
            const SizedBox(width: 12),
            const Text(
              'ZOOM OPTICS',
              style: TextStyle(
                color: Color(0xFFE8F1FF),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<double>(
          valueListenable: game.zoomLevel,
          builder: (context, zoom, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFFE8F1FF).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Text(
                'MAGNIFICATION: ${zoom.toStringAsFixed(2)}x',
                style: TextStyle(
                  color: const Color(0xFFE8F1FF).withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ZoomControls extends StatelessWidget {
  final OrbitalsGame game;
  final VoidCallback onBack;

  const _ZoomControls({
    required this.game,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MenuButton(
          onPressed: onBack,
          icon: Icons.arrow_back,
          label: 'BACK',
        ),
        MenuButton(
          onPressed: () => game.zoomOut(),
          icon: Icons.remove,
          label: 'OUT',
        ),
        MenuButton(
          onPressed: () => game.resetZoom(),
          icon: Icons.zoom_out_map,
          label: 'RESET',
          isPrimary: true,
        ),
        MenuButton(
          onPressed: () => game.zoomIn(),
          icon: Icons.add,
          label: 'IN',
        ),
      ],
    );
  }
}

class _OverlayLayout extends StatelessWidget {
  final Widget top;
  final Widget bottom;

  const _OverlayLayout({
    required this.top,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          alignment: Alignment.center,
          child: top,
        ),
        const Expanded(child: SizedBox.shrink()),
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: bottom,
        ),
      ],
    );
  }
}
