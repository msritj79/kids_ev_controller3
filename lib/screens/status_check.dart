import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ev_controller/providers/mqtt_service_provider.dart';

class StatusCheckScreen extends ConsumerStatefulWidget {
  const StatusCheckScreen({super.key});

  @override
  ConsumerState<StatusCheckScreen> createState() => _StatusCheckScreenState();
}

class _StatusCheckScreenState extends ConsumerState<StatusCheckScreen> {
  String doorStatus = 'Closed';
  String doorLock = 'Unlocked';
  String windowsStatus = 'Closed';
  String headlightsStatus = 'OFF';
  String taillightsStatus = 'OFF';
  String hazardLightsStatus = 'OFF';
  String updateDateTime = 'Last updated: Never';

  @override
  void initState() {
    super.initState();

    // MQTTのトピックにサブスクライブ
    // ref.read(beebotteMQTTServiceProvider.notifier).connect();
    // ref.read(beebotteMQTTServiceProvider.notifier).subscribe('LC500/command');
    // ref.read(beebotteMQTTServiceProvider.notifier).subscribe('LC500/status');
  }

  void updateState() {
    // MQTTの状態を監視
    ref.listen<AsyncValue<List<MqttState>>>(beebotteMQTTServiceProvider,
        (previous, next) {
      next.whenData((messages) {
        for (var message in messages) {
          var payload = jsonDecode(message.payload);

          setState(() {
            if (payload['doorStatus'] != null) {
              doorStatus = payload['doorStatus'];
            }
            if (payload['doorLock'] != null) {
              doorLock = payload['doorLock'];
            }
            if (payload['windows'] != null) {
              windowsStatus = payload['windows'];
            }
            if (payload['headLight'] != null) {
              headlightsStatus = payload['headLight'];
            }
            if (payload['tailLight'] != null) {
              taillightsStatus = payload['tailLight'];
            }
            if (payload['hazardLight'] != null) {
              hazardLightsStatus = payload['hazardLight'];
            }
            updateDateTime = 'Last updated: ${DateTime.now()}';
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    updateState();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 更新日時
        Text(
          updateDateTime,
          style: const TextStyle(color: Colors.grey),
        ),

        // ドアセクション
        const SectionTitle(title: 'Doors'),
        StatusRow(label: 'Door Status', status: doorStatus),
        StatusRow(label: 'Door Lock', status: doorLock),

        // ウィンドウセクション
        const SectionTitle(title: 'Windows'),
        StatusRow(label: 'Windows', status: windowsStatus),

        // ライトセクション
        const SectionTitle(title: 'Lights'),
        StatusRow(label: 'Headlights', status: headlightsStatus),
        StatusRow(label: 'Taillights', status: taillightsStatus),
        StatusRow(label: 'Hazard Lights', status: hazardLightsStatus),

        // その他
        const SectionTitle(title: 'Other'),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final String label;
  final String status;

  const StatusRow({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
