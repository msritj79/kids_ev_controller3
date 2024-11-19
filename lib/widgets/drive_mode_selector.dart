import 'package:flutter/material.dart';

class DriveModeSelector extends StatefulWidget {
  const DriveModeSelector({super.key});

  @override
  State<DriveModeSelector> createState() => _DriveModeSelectorState();
}

class _DriveModeSelectorState extends State<DriveModeSelector> {
  String selectedMode = 'normal';
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
              Icon(Icons.directions_car),
              SizedBox(width: 8),
              Text(
                'Drive Mode',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildModeButton('Normal', 'normal'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeButton('Sport', 'sport'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeButton('Eco', 'eco'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, String mode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedMode == mode ? Colors.blue : Colors.white,
        foregroundColor: selectedMode == mode ? Colors.white : Colors.black,
      ),
      onPressed: () => setState(() => selectedMode = mode),
      child: Text(
        label,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
