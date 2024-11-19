import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kids_ev_controller/providers/mqtt_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ev_controller/widgets/body_light.dart';
import 'package:kids_ev_controller/widgets/color_picker.dart';

class BodyControlScreen extends ConsumerStatefulWidget {
  const BodyControlScreen({super.key});

  @override
  ConsumerState<BodyControlScreen> createState() => _BodyControlScreenState();
}

class _BodyControlScreenState extends ConsumerState<BodyControlScreen> {
  bool _isHeadlightPressed = false;
  bool _isTaillightPressed = false;

  bool lightTheme = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final limitHeight = screenHeight - 160;
    // ref.watch(beebotteMQTTServiceProvider);
    final double imageAspectRatio = 700 / 628; // ratio of width to height
    final double expandRatio =
        1.9; // param to expand the image to fit the screen
    final double calculatedWidth = screenWidth * expandRatio;
    final double calculatedHeight =
        screenWidth * expandRatio / imageAspectRatio;
    final bool isHeightExceeding = calculatedHeight > limitHeight;
    final double imageWidth =
        isHeightExceeding ? limitHeight * imageAspectRatio : calculatedWidth;
    final double imageHeight =
        isHeightExceeding ? limitHeight : calculatedHeight;

    return Column(children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            // Dynamically adjust width and height based on screen and image constraints
            width: imageWidth,
            height: imageHeight,
            child: _isHeadlightPressed && !_isTaillightPressed
                ? const Image(
                    image: AssetImage('assets/LC500_headlightOn.jpg'),
                    fit: BoxFit.cover)
                : _isTaillightPressed && !_isHeadlightPressed
                    ? const Image(
                        image: AssetImage('assets/LC500_taillightOn.jpg'),
                        fit: BoxFit.cover)
                    : _isHeadlightPressed && _isTaillightPressed
                        ? const Image(
                            image: AssetImage(
                                'assets/LC500_headlightTaillightOn.jpg'),
                            fit: BoxFit.cover)
                        : const Image(
                            image: AssetImage('assets/LC500.jpg'),
                            fit: BoxFit.cover),
          ),

          HeadlightWidget(
            isPressed: _isHeadlightPressed,
            onTap: _toggleHeadlights,
            position:
                // const Offset(185, 425),
                Offset(screenWidth / 2 - imageWidth * 0.19, imageHeight * 0.82),
          ),
          // Right headlight
          HeadlightWidget(
            isPressed: _isHeadlightPressed,
            onTap: _toggleHeadlights,
            position:
                // const Offset(-185, 425), // Adjust based on the headlight position
                Offset(screenWidth / 2 + imageWidth * 0.15, imageHeight * 0.82),
          ),
          TaillightWidget(
            isPressed: _isTaillightPressed,
            onTap: _toggleTaillights,
            position:
                // const Offset(200, 20), // Adjust based on the headlight position
                Offset(screenWidth / 2 - imageWidth * 0.15, imageHeight * 0.03),
          ),

          // Right headlight
          TaillightWidget(
            isPressed: _isTaillightPressed,
            onTap: _toggleTaillights,
            position:
                // const Offset(-200, 20), // Adjust based on the headlight position
                Offset(screenWidth / 2 + imageWidth * 0.11, imageHeight * 0.03),
          ),
        ],
      ),
      MyColorPicker(
        onChangeColor: (color) => _setIllumi(color),
      )
    ]);
  }

  // color: {r, g, b, }
  void _setIllumi(Color color) {
    final illumi_data = {
      "status": "on",
      "r": color.red,
      "g": color.green,
      "b": color.blue,
      "a": color.alpha,
    };
    print('set_Illumi: $illumi_data');
    ref
        .read(beebotteMQTTServiceProvider.notifier)
        .publish('LC500/command', jsonEncode({"illumi": illumi_data}));
  }

  void _toggleHeadlights() {
    // ヘッドライトをオン/オフする関数
    setState(() {
      _isHeadlightPressed = !_isHeadlightPressed; // Toggle the state
    });
    print('Headlights toggled: $_isHeadlightPressed');
    ref.read(beebotteMQTTServiceProvider.notifier).publish(
        'LC500/command',
        _isHeadlightPressed
            ? jsonEncode({"headLight": "ON"})
            : jsonEncode({"headLight": "OFF"}));
  }

  void _toggleTaillights() {
    // ヘッドライトをオン/オフする関数
    setState(() {
      _isTaillightPressed = !_isTaillightPressed; // Toggle the state
    });
    print('Taillights toggled: $_isTaillightPressed');
    ref.read(beebotteMQTTServiceProvider.notifier).publish(
        'LC500/command',
        _isTaillightPressed
            ? jsonEncode({"tailLight": "ON"})
            : jsonEncode({"tailLight": "OFF"}));
  }

  void _honkHorn() {
    // ホーンを鳴らす関数
    print('Horn honked');
  }

  void _playMusic() {
    // ミュージックを再生する関数
    print('Music played');
  }

  @override
  void dispose() {
    ref
        .read(beebotteMQTTServiceProvider.notifier)
        .client
        .disconnect(); // ウィジェットが破棄されたときにMQTTクライアントを切断
    super.dispose();
  }
}
