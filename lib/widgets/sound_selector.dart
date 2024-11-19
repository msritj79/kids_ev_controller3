import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kids_ev_controller/providers/mqtt_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SoundSelector extends ConsumerStatefulWidget {
  const SoundSelector({super.key});

  @override
  ConsumerState<SoundSelector> createState() => _SoundSelectorState();
}

class _SoundSelectorState extends ConsumerState<SoundSelector> {
  String selectedSound = 'sports';
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
              Icon(Icons.volume_up),
              SizedBox(width: 8),
              Text(
                'Engine Sound',
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
                    child: _buildSoundButton('None', 'none'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSoundButton('Electric Vehicle', 'ev'),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildSoundButton('Sports Car', 'sports'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSoundButton('Racing Car', 'race'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundButton(String label, String sound) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedSound == sound ? Colors.blue : Colors.white,
        foregroundColor: selectedSound == sound ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: () {
        setState(() => selectedSound = sound);
        _setEngineSound();
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _setEngineSound() {
    print('engine_sound: $selectedSound');
    ref
        .read(beebotteMQTTServiceProvider.notifier)
        .publish('LC500/command', jsonEncode({"engine_sound": selectedSound}));
  }
}
