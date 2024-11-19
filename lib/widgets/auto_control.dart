import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kids_ev_controller/providers/mqtt_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class AutoControl extends ConsumerStatefulWidget {
  const AutoControl({super.key});

  @override
  ConsumerState<AutoControl> createState() => _AutoControlState();
}

class _AutoControlState extends ConsumerState<AutoControl> {
  // bool hasAutoParkingPushed = false;
  // bool hasAutoBrakingPushed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.smart_toy),
              SizedBox(width: 8),
              Text(
                'Auto Control',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildAutoControlButton('Auto Parking', 'parking'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildAutoControlButton(
                        'Auto Emergency Braking', 'aeb'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAutoControlButton(String label, String function) {
    bool buttonPushed = false;

    void _callFunction() {
      setState(() {
        buttonPushed = !buttonPushed;
        if (function == 'parking' && buttonPushed) {
          label = 'Auto Parking: in progress';
        }
      });
      if (function == 'parking') {
        _setAutoParking();
      }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonPushed ? Colors.blue : Colors.white,
        foregroundColor: buttonPushed ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: _callFunction,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _setAutoParking() {
    print('auto parking');
    // ref
    //     .read(beebotteMQTTServiceProvider.notifier)
    //     .publish('LC500/command', jsonEncode({"engine_sound": selectedSound}));
  }

  void _setAutoBraking() {
    print('auto braking');
  }
}
