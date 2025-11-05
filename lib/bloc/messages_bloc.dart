import 'package:messaging_example/api/messages_api.dart';
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';
import 'package:messaging_example/models/websocket_subscription.dart';
import 'package:rxdart/rxdart.dart';

class MessagesBloc with Logger {
  static MessagesBloc? _instance;
  final MessagesApi _api;

  factory MessagesBloc({MessagesApi? api}) {
    return _instance ??= MessagesBloc._(api);
  }

  MessagesBloc._([
    MessagesApi? api,
  ]) : _api = api ?? MessagesApi() {
    _subscribeToChatChannel();
  }

  final PublishSubject<List<Message>> _subject = PublishSubject();
  Stream<List<Message>> get stream => _subject.stream;

  Future<void> fetchMessagesFor(Chat chat) async {
    final messages = await _api.fetchMessagesFor(chat);
    _subject.add(messages);
  }

  Future<Message> sendMessage(Chat chat, String body) {
    return _api.sendMessage(chat, body);
  }

  WebsocketSubscription _subscribeToChatChannel() {
    return WebsocketSubscription(
      channel: 'ChatChannel',
      onData: (Map<String, dynamic> data) {
        final message = Message.fromJson(data);
        return message;
      },
    );
  }
}
