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

  final BehaviorSubject<List<Message>> _subject = BehaviorSubject();
  Stream<List<Message>> get stream => _subject.stream;
  List<Message> get messages => _subject.value;

  Future<void> fetchMessagesFor(Chat chat) async {
    final messages = await _api.fetchMessagesFor(chat);
    _subject.add(messages);
  }

  Future<Message> send(Message message) async {
    try {
      // Add pending message.
      _subject.add(messages..add(message));

      final persistedMessage = await _api.sendMessage(message);
      final updatedMessages = messages
        ..remove(message)
        ..add(persistedMessage);
      _subject.add(updatedMessages);

      return persistedMessage;
    } catch (err, st) {
      log.warning('${err.runtimeType} occurred while sending message', err, st);
      rethrow;
    }
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
