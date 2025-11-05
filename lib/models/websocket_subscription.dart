import 'dart:ui';

import 'package:messaging_example/api/websocket_api.dart';
import 'package:messaging_example/mixin/logger.dart';

typedef Json = Map<String, dynamic>;

class WebsocketSubscription with Logger {
  /// Must be Pascalcase and end with 'Channel'.
  ///
  /// Example: 'ChatChannel';
  final String channel;
  final VoidCallback? _onSubscribed;
  final Function(Json)? _onData;
  final VoidCallback? _onDisconnected;

  WebsocketSubscription({
    required this.channel,
    VoidCallback? onSubscribed,
    Function(Json)? onData,
    VoidCallback? onDisconnected,
  }) : _onSubscribed = onSubscribed,
       _onData = onData,
       _onDisconnected = onDisconnected {
    WebsocketApi().subscribeTo(this);
  }

  @override
  String get loggerName => channel;

  void onSubscribed() {
    log.info('Successfully subscribed to websocket.');
    _onSubscribed?.call();
  }

  void onData(Json data) {
    log.info('Received data via websocket:');
    log.info(data);
    _onData?.call(data);
  }

  void onDisconnected() {
    log.info('Disconnected from websocket.');
    _onDisconnected?.call();
  }
}
