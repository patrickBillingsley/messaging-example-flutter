import 'package:flutter/animation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part './_action_cable_implementation.dart';

class WebsocketApi {
  final _client = _ActionCableImplementation();

  void subscribeTo({required String channel, VoidCallback? onSubscribed}) {
    _client.subscribeTo(channel, onSubscribed: onSubscribed);
  }
}
