import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:messaging_example/models/websocket_subscription.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum MessageType {
  welcome,
  ping,
}

class ActionCableService with Logger {
  static const String websocketUrl = 'ws://10.0.2.2:3000/cable'; // Works locally with Android emulator.
  final WebSocketChannel _cable = WebSocketChannel.connect(Uri.parse(websocketUrl));

  final Map<String, VoidCallback?> _onSubscribedCallbacks = {};
  final Map<String, Function?> _onDataCallbacks = {};

  bool _connected = false;

  Future<void> connect() async {
    if (_connected) return;

    log.info('Cable connecting...');
    await _cable.ready;
    log.info('Cable ready!');

    _cable.stream.listen((data) {
      _cable.sink.add(data);

      data = jsonDecode(data);
      switch (data['type']) {
        case 'welcome':
        case 'ping':
          _connected = true;
        case 'confirm_subscription':
          final channel = jsonDecode(data['identifier'])['channel'];
          _onSubscribedCallbacks[channel]?.call();
        default:
          final channel = jsonDecode(data['identifier'])['channel'];
          final message = data['message'];
          if (channel != null && message != null) {
            _onDataCallbacks[channel]?.call(message);
          }
      }
    });
  }

  Future<void> subscribeTo<T extends Object?>(WebsocketSubscription subscription) async {
    _onSubscribedCallbacks[subscription.channel] ??= subscription.onSubscribed;
    _onDataCallbacks[subscription.channel] ??= subscription.onData;

    await _cable.ready;

    _cable.sink.add(
      jsonEncode({
        'identifier': jsonEncode({'channel': subscription.channel}),
        'command': 'subscribe',
      }),
    );
  }
}
