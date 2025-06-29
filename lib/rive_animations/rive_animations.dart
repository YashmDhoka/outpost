// import 'dart:developer' show log;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:rive/rive.dart';

// class RiveAnimations extends StatefulWidget {
//   const RiveAnimations({super.key});

//   @override
//   State<RiveAnimations> createState() => _RiveAnimationsState();
// }

// class _RiveAnimationsState extends State<RiveAnimations> {
//   late RiveAnimationController _controller;
//   Artboard? _artboard;
//   bool _isHovered = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeRiveAnimations();
//   }

//   void initializeRiveAnimations() async {
//     await RiveFile.initialize();
//     rootBundle.load('/rive/bouncing_ball/bouncing_ball.riv').then((data) async {
//       final file = RiveFile.import(data);
//       final artboard = file.mainArtboard;
//       final controller = SimpleAnimation('idle'); // default state
//       artboard.addController(controller);
//       setState(() {
//         _artboard = artboard;
//         _controller = controller;
//       });
//     });
//   }

//   void _playHoverAnimation() {
//     log('playing hover animation');
//     if (_artboard == null) return;
//     _artboard!.addController(
//       SimpleAnimation('Boucing animation'), // Your hover animation name in Rive
//     );
//   }

//   void _playIdleAnimation() {
//     if (_artboard == null) return;
//     _artboard!.addController(
//       SimpleAnimation('idle'), // Back to idle
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) {
//         _playHoverAnimation();
//         setState(() => _isHovered = true);
//       },
//       onExit: (_) {
//         _playIdleAnimation();
//         setState(() => _isHovered = false);
//       },
//       child: _artboard == null
//           ? const SizedBox.shrink()
//           : Rive(artboard: _artboard!),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveAnimations extends StatefulWidget {
  const RiveAnimations({super.key});

  @override
  State<RiveAnimations> createState() => _RiveAnimationsState();
}

class _RiveAnimationsState extends State<RiveAnimations> {
  Artboard? _artboard;
  SMITrigger? _hoverTrigger;

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  Future<void> _loadRive() async {
    final data = await rootBundle.load(
      'assets/animations/my_state_machine.riv',
    );
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    final controller = StateMachineController.fromArtboard(
      artboard,
      'MainStateMachine',
    );
    if (controller != null) {
      artboard.addController(controller);
      _hoverTrigger = controller.findInput<bool>('hover') as SMITrigger?;
    } else {
      debugPrint('StateMachineController not found!');
    }

    setState(() => _artboard = artboard);
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _hoverTrigger?.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) {}, // optional: return to idle if needed
      child: _artboard == null
          ? const SizedBox(width: 300, height: 300)
          : SizedBox(
              width: 300,
              height: 300,
              child: Rive(artboard: _artboard!),
            ),
    );
  }
}
