import 'dart:ui';

import 'package:messaging_example/api/websocket_api.dart';

class WebsocketSubscription {
  final String channel;
  final VoidCallback? onSubscribed;
  final Function? onData;

  const WebsocketSubscription({
    required this.channel,
    this.onSubscribed,
    required this.onData,
  });

  void subscribe() => WebsocketApi().subscribeTo(this);
}
