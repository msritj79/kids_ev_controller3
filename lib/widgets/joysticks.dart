import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  final Axis direction;
  final ValueChanged<int> onUpdate;

  Joystick({
    required this.direction,
    required this.onUpdate,
  });

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  double _position = 0.0;
  int _position_percent = 0;
  final double _baseRadius = 70;
  final double _joystickRadius = 30;

  void _updateJoystickPosition(Offset globalPosition) {
    double newPosition;
    if (widget.direction == Axis.vertical) {
      newPosition = globalPosition.dy - _baseRadius;
      newPosition = newPosition.clamp(
        -(_baseRadius - _joystickRadius),
        _baseRadius - _joystickRadius,
      );
    } else {
      newPosition = globalPosition.dx - _baseRadius;
      newPosition = newPosition.clamp(
        -(_baseRadius - _joystickRadius),
        _baseRadius - _joystickRadius,
      );
    }
    setState(() {
      _position = newPosition;
      _position_percent =
          (-_position / (_baseRadius - _joystickRadius) * 100).toInt();
    });
    widget.onUpdate(_position_percent);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _updateJoystickPosition(details.localPosition);
      },
      onPanEnd: (details) {
        setState(() {
          _position = 0.0;
          _position_percent = 0;
        });
        widget.onUpdate(_position_percent);
      },
      // large circle: range of joystick motion
      child: Container(
        width: _baseRadius * 2,
        height: _baseRadius * 2,
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.direction == Axis.vertical
                ? PairArrow(direction: Axis.vertical, space: 80)
                : PairArrow(direction: Axis.horizontal, space: 80),

            // small circle: joystick
            Positioned(
              left: widget.direction == Axis.vertical
                  ? _baseRadius - _joystickRadius
                  : _baseRadius - _joystickRadius + _position,
              top: widget.direction == Axis.vertical
                  ? _baseRadius - _joystickRadius + _position
                  : _baseRadius - _joystickRadius,
              child: Container(
                width: _joystickRadius * 2,
                height: _joystickRadius * 2,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PairArrow extends StatelessWidget {
  final Axis direction;
  final double space;

  const PairArrow({Key? key, required this.direction, required this.space})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? RotatedBox(
            quarterTurns: 1,
            child: horizontalArrows(),
          )
        : horizontalArrows();
  }

  Widget horizontalArrows() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_left,
            color: Colors.black.withOpacity(0.7),
            size: 30,
          ),
          SizedBox(
            width: space,
            height: space,
          ),
          Icon(
            Icons.arrow_right,
            color: Colors.black.withOpacity(0.7),
            size: 30,
          ),
        ]);
  }
}
