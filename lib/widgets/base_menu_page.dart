import 'package:flutter/material.dart';
import '../orbitals_game.dart';

typedef PushCallback = void Function<T extends BaseMenuPage>();

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
