import 'package:messaging_example/models/websocket_subscription.dart';
import 'package:messaging_example/services/action_cable_service.dart';

class WebsocketApi {
  final _client = ActionCableService();

  Future<void> subscribeTo(WebsocketSubscription subscription) async {
    await _client.connect();
    await _client.subscribeTo(subscription);
  }
}
