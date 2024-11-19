import 'package:flutter/material.dart';

class HeadlightWidget extends StatelessWidget {
  final bool isPressed;
  final VoidCallback onTap;
  final Offset position;

  const HeadlightWidget({
    Key? key,
    required this.isPressed,
    required this.onTap,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx > 0 ? position.dx : null,
      right: position.dx < 0 ? -position.dx : null,
      top: position.dy,
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
              color: isPressed
                  ? Colors.yellow.withOpacity(0.5) // 半透明の黄色（50%透明）
                  : Colors.black.withOpacity(0.2), // 非表示
              // shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(500),
            ),
            // color: isPressed ? Colors.yellow : Colors.black, // Make it invisible
          ),
        ),
      ),
    );
  }
}

class TaillightWidget extends StatelessWidget {
  final bool isPressed;
  final VoidCallback onTap;
  final Offset position;

  const TaillightWidget({
    Key? key,
    required this.isPressed,
    required this.onTap,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx > 0 ? position.dx : null,
      right: position.dx < 0 ? -position.dx : null,
      top: position.dy,
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
              color: isPressed
                  ? Colors.red.withOpacity(0.5) // 半透明の黄色（50%透明）
                  : Colors.white.withOpacity(0.2), // 非表示
              // shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(500),
            ),
            // color: isPressed ? Colors.yellow : Colors.black, // Make it invisible
          ),
        ),
      ),
    );
  }
}
