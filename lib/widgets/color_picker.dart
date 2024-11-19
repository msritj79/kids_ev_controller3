import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MyColorPicker extends StatefulWidget {
  final Function(Color) onChangeColor;
  const MyColorPicker({super.key, required this.onChangeColor});

  @override
  State<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  // Color selectedColor = Colors.blue;
  Color pickerColor = Colors.blue;
  bool isOffPressed = false; // Track OFF button state
  bool isAutoPressed = false; // Track Auto button state

  void _changeColor(Color color) {
    print("!!!!!!!!!!!");
    setState(() {
      isOffPressed = false;
      isAutoPressed = false;
    });
    pickerColor = color;
    widget.onChangeColor(pickerColor);
    // when manually changing color, ensure both mode are deselected
  }

  void _turnOFF() {}
  void _turnAuto() {}
  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change illumination color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: _changeColor,
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            // Use StatefulBuilder for managing button states
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOffPressed
                            ? Colors.blue
                            : Colors.grey, // Toggle color
                      ),
                      onPressed: () {
                        setState(() {
                          isOffPressed = !isOffPressed;
                          isAutoPressed = false; // Ensure Auto is deselected
                        });
                        _turnOFF(); // Call the OFF function
                      },
                      child: const Text('OFF'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAutoPressed
                            ? Colors.blue
                            : Colors.grey, // Toggle color
                      ),
                      onPressed: () {
                        setState(() {
                          isAutoPressed = !isAutoPressed;
                          isOffPressed = false; // Ensure OFF is deselected
                        });
                        _turnAuto(); // Call the Auto function
                      },
                      child: const Text('Auto'),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _showPicker(context);
      },
      icon: Icon(Icons.color_lens), // アイコン
      label: Text('Illumi'), // テキスト
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // ボタンの背景色を青色に設定
      ),
    );
  }
}

// Just an example of how to use/interpret/format text input's result.

// class ColorPicker extends StatefulWidget {
//   @override
//   _ColorPickerState createState() => _ColorPickerState();
// }

// class _ColorPickerState extends State<ColorPicker> {
//   Color _selectedColor = Colors.white;

//   void _onTapDown(TapDownDetails details, BuildContext context) {
//     RenderBox box = context.findRenderObject() as RenderBox;
//     Offset localPosition = box.globalToLocal(details.globalPosition);

//     // 円の中心とタップ位置の距離を計算
//     double dx = localPosition.dx - box.size.width / 2;
//     double dy = localPosition.dy - box.size.height / 2;
//     double distance = sqrt(dx * dx + dy * dy);

//     // 円の半径を定義し、範囲内のタップのみ色を取得
//     double radius = min(box.size.width, box.size.height) / 2;
//     if (distance <= radius) {
//       double hue = (atan2(dy, dx) * 180 / pi + 180) % 360; // タップの角度を色相に変換
//       _selectedColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTapDown: (details) => _onTapDown(details, context),
//         child: Container(
//           width: 200,
//           height: 200,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: SweepGradient(
//               // colors: [
//               //   Colors.red,
//               //   Colors.yellow,
//               //   Colors.green,
//               //   Colors.cyan,
//               //   Colors.blue,
//               //   Colors.purple,
//               //   Colors.red
//               // ],
//               // colors: [
//               //   Color.fromRGBO(255, 0, 0, 1.0),
//               //   // Colors.yellow,
//               //   Color.fromRGBO(0, 0, 255, 1.0),
//               //   // Colors.cyan,
//               //   Color.fromRGBO(0, 255, 0, 1.0),
//               //   // Colors.purple,
//               //   Color.fromRGBO(255, 0, 0, 1.0),
//               // ],
//               colors: [
//                 HSVColor.fromAHSV(1.0, 1.0, 1.0, 1.0).toColor(),
//                 HSVColor.fromAHSV(1.0, 1.0, 1.0, 1.0).toColor(),
//                 HSVColor.fromAHSV(1.0, 1.0, 1.0, 1.0).toColor(),
//                 HSVColor.fromAHSV(1.0, 0.3, 1.0, 1.0).toColor(),
//                 HSVColor.fromAHSV(1.0, 1.0, 1.0, 1.0).toColor(),
//                 HSVColor.fromAHSV(1.0, 1.0, 1.0, 1.0).toColor()
//               ],
//             ),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Selected Color'),
//                 Container(
//                   width: 30,
//                   height: 30,
//                   color: _selectedColor,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                     'RGB: (${_selectedColor.red}, ${_selectedColor.green}, ${_selectedColor.blue})'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
