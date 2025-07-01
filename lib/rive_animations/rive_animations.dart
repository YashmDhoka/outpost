import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';

class RiveAnimations extends StatefulWidget {
  const RiveAnimations({super.key});

  @override
  State<RiveAnimations> createState() => _RiveAnimationsState();
}

class _RiveAnimationsState extends State<RiveAnimations> {
  Artboard? _artboard;
  // This will hold the boolean input from our Rive State Machine
  SMIBool? _hoverInput;

  @override
  void initState() {
    super.initState();
    initializeRiveAnimations();
  }

  void initializeRiveAnimations() async {
    await RiveFile.initialize();
    rootBundle.load('/rive/bouncing_ball/bouncing_ball.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      // Find the state machine controller by its name
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );

      if (controller != null) {
        artboard.addController(controller);
        // Find the boolean input by its name
        _hoverInput = controller.findInput<bool>('Boolean 1') as SMIBool?;
      }

      setState(() => _artboard = artboard);
    });
  }

  void _onHover(bool isHovering) {
    if (_hoverInput != null) {
      log('Hover state changed: $isHovering');
      _hoverInput!.value = isHovering;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: _artboard == null
          ? const Center(child: CircularProgressIndicator())
          : Rive(artboard: _artboard!),
    );
  }
}
