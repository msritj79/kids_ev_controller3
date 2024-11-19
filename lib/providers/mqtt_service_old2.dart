import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

class BeebotteMQTTService {
  final String clientId = 'seijimurata';
  final String serverUri = 'mqtt.beebotte.com';
  final int port = 1883;
  final String token = 'token_PKz56l4BziahekNq'; // Beebotteトークン
  late MqttServerClient client;

  BeebotteMQTTService() {
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
  }

  Future<void> connect() async {
    try {
      await client.connect();
    } catch (e) {
      print('MQTT client exception: $e');
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected successfully');
    } else {
      print('MQTT client connection failed: ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    final command = {
      "action": "control",
      "payload": {
        "light": true,
        "accelerate": 5,
        "steering": 30,
        "app": "play_music",
        "": ""
      }
    };
    // final ccmd_json = jsonEncode(command);

    builder.addString(message);
    builder.addString(jsonEncode(command));
    // トピックにメッセージをPublish
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    print('Publishing: topic: $topic, message:$message');
  }

  void subscribe(String topic) {
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
      print(
          'Change notification:: topic is <${messages[0].topic}>, payload is <-- $payload -->');
    });

    // /// If needed you can listen for published messages that have completed the publishing
    // /// handshake which is Qos dependant. Any message received on this stream has completed its
    // /// publishing handshake with the broker.
    // client.published!.listen((MqttPublishMessage message) {
    //   print('Published notification:: topic is ${message.variableHeader!
    //       .topicName}, with Qos ${message.header!.qos}');
    // });
  }

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
