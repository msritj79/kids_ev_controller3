import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'mqtt_service_provider.g.dart'; // 生成されるファイル

// MQTTStateのモデルクラス
class MqttState {
  final String topic;
  final String payload;

  MqttState({required this.topic, required this.payload});
}

@riverpod
class BeebotteMQTTService extends _$BeebotteMQTTService {
  final String clientId = 'seijimurata';
  final String serverUri = 'mqtt.beebotte.com';
  final int port = 1883;
  final String token = dotenv.env['BEEBOTTE_TOKEN']!;
  late MqttServerClient client;

  @override
  AsyncValue<List<MqttState>> build() {
    state = const AsyncValue.data([]);

    client = MqttServerClient.withPort(serverUri, clientId, port);
    client.logging(on: false);
    client.keepAlivePeriod = 60;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = onDisconnected;

    /// Add the successful connection callback
    client.onConnected = onConnected;

    /// Add a subscribed callback
    client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs('token:$token', '') // 認証情報
        .startClean() // 新しいセッションの開始
        .withWillQos(MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;
    return state;

    // await connect();
  }

  Future<void> connectAndSubscribe(String topic) async {
    try {
      await client.connect();
    } catch (e, stacktrace) {
      print('MQTT client exception: $e');
      state = AsyncValue.error(
        e,
        stacktrace,
      );
      return;
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected successfully');
      subscribe(topic);
    } else {
      print('MQTT client connection failed: ${client.connectionStatus}');
      client.disconnect();
      state = AsyncValue.error('Connection failed', StackTrace.current);
    }
  }

  // messageは以下のようなJson形式
  // {"headLight": "ON", "accelerate": 5, "steering": 30, "app": "play_music"}
  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    // builder.addString(jsonEncode(message));
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    print('Publishing: topic: $topic, message:$message');
  }

  Future subscribe(String topic) async {
    print('Subscribing: topic: $topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    /// In general you should listen here as soon as possible after connecting, you will not receive any
    /// publish messages until you do this.
    /// Also you must re-listen after disconnecting.
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMess = messages![0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final receivedMessage =
          MqttState(topic: messages[0].topic, payload: payload);
      // 新しいメッセージを追加してAsyncValueの状態を更新
      state = AsyncValue.data([...(state.value ?? []), receivedMessage]);
      print(
          'Change notification:: topic is <${messages[0].topic}>, payload is <-- $payload -->');
    });
  }

  // /// If needed you can listen for published messages that have completed the publishing
  // /// handshake which is Qos dependant. Any message received on this stream has completed its
  // /// publishing handshake with the broker.
  // client.published!.listen((MqttPublishMessage message) {
  //   print('Published notification:: topic is ${message.variableHeader!
  //       .topicName}, with Qos ${message.header!.qos}');
  // });

  /// The successful connect callback
  void onConnected() {
    print('OnConnected callback - Client connection was successful');
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('OnSubscribe callback - Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('OnDisconnected callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    }
  }
}
