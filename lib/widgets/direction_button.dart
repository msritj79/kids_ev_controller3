import 'package:flutter/material.dart';

class DirectionButton extends StatelessWidget {
  final ValueChanged<String> onUpdate;
  const DirectionButton({super.key, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDirectionButton(Icons.arrow_left, 'left'),
        const SizedBox(width: 16),
        _buildDirectionButton(Icons.arrow_right, 'right'),
      ],
    );
  }

  Widget _buildDirectionButton(IconData icon, String direction) {
    return Material(
      color: Colors.grey[300]!.withOpacity(0.7),
      // child: Ink(
      //   decoration: BoxDecoration(
      //     //   border: Border.all(color: Colors.grey),
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      child: InkWell(
        onTapDown: (_) => onUpdate(direction),
        // onTapUp: (_) => _handleDirectionPress(direction, false),
        // onTapCancel: () => _handleDirectionPress(direction, false),
        child: Container(
          width: 64,
          height: 64,
          child: Icon(
            icon,
            size: 32,
          ),
        ),
        // ),
      ),
      // )
    );
  }
}
