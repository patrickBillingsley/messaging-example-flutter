part of './websocket_api.dart';

class _ActionCableImplementation {
  final WebSocketChannel _cable = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000/cable'));

  void subscribeTo<T extends Object?>(
    String channel, {
    VoidCallback? onSubscribed,
  }) async {
    print('Awaiting cable ready.');
    await _cable.ready;
    print('Cable ready. Connecting...');

    _cable.stream.listen(_cable.sink.add);
    print('Connected!');
  }
}
