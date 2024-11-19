import 'package:flutter/material.dart';
import 'package:kids_ev_controller/widgets/drive_mode_selector.dart';
import 'package:kids_ev_controller/widgets/monitor.dart';
import 'package:kids_ev_controller/widgets/sound_selector.dart';
import '../widgets/joysticks.dart';
import '../widgets/direction_button.dart';
import 'dart:convert';

import 'package:kids_ev_controller/providers/mqtt_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/auto_control.dart';
// class DynamicControlScreen extends StatelessWidget {
//   const DynamicControlScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text('Dynamic Control', style: TextStyle(fontSize: 24)),
//           SizedBox(height: 20),
//           Icon(Icons.directions_car, size: 150),
//         ],
//       ),
//     );
//   }
// }

class MotionControlScreen extends ConsumerStatefulWidget {
  const MotionControlScreen({super.key});

  @override
  ConsumerState<MotionControlScreen> createState() =>
      _MotionControlScreenState();
}

class _MotionControlScreenState extends ConsumerState<MotionControlScreen> {
  double xPosition = 0;
  double yPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const DriveModeSelector(),
      const SoundSelector(),
      const AutoControl(),
      const Expanded(child: Monitor()),
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Joystick(direction: Axis.vertical, onUpdate: _setAccel),
              const SizedBox(width: 40),
              DirectionButton(onUpdate: _setSteer),
            ]),
          )),
    ]);
  }

  void _setAccel(int accelValue) {
    print('set_accel: $accelValue');
    ref
        .read(beebotteMQTTServiceProvider.notifier)
        .publish('LC500/command', jsonEncode({"accel": accelValue}));
  }

  void _setSteer(String direction) {
    print('set_steer: $direction');
    ref
        .read(beebotteMQTTServiceProvider.notifier)
        .publish('LC500/command', jsonEncode({"steer": direction}));
  }
}
