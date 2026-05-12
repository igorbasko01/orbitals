import 'package:flutter/material.dart';
import '../orbitals_game.dart';

typedef PushCallback = void Function(BaseMenuPage page);

/// Defines the contract for all menu pages in the game's HUD.
abstract class BaseMenuPage {
  /// The unique identifier for this overlay, defaults to the class name.
  String get name => runtimeType.toString();

  /// Builds the widget for this menu.
  /// [pop] and [push] are injected navigation callbacks.
  Widget build(
    BuildContext context,
    OrbitalsGame game,
    VoidCallback pop,
    PushCallback push,
  );
}

/// A shared layout for all game overlays that maintains the top/bottom HUD split.
class HUDLayout extends StatelessWidget {
  final Widget top;
  final Widget bottom;

  const HUDLayout({
    super.key,
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
