import 'package:messaging_example/api/messages_api.dart';
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';
import 'package:messaging_example/models/websocket_subscription.dart';
import 'package:messaging_example/types.dart';
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

  final BehaviorSubject<Map<String, List<Message>>> _subject = BehaviorSubject.seeded({});
  Stream<List<Message>?> streamFor(Chat chat) => _subject.stream.map((chats) => chats[chat.id]);
  List<Message> messagesFor(Chat chat) => List.from(_subject.value[chat.id] ?? []);
  Map<String, List<Message>> get messageMap => Map.from(_subject.value);

  Future<void> fetchMessagesFor(Chat chat) async {
    final messages = await _api.fetchMessagesFor(chat);
    _subject.add(messageMap..[chat.id] = messages);
  }

  Future<Message> send(Message message) async {
    try {
      final pendingMessages = messageMap..[message.chatId] ??= [];
      pendingMessages[message.chatId]!.add(message);
      _subject.add(pendingMessages);

      final persistedMessage = await _api.sendMessage(message);
      final persistedMessages = messageMap..[message.chatId]!.replace(message, next: persistedMessage);
      _subject.add(persistedMessages);

      return persistedMessage;
    } catch (err, st) {
      log.warning('${err.runtimeType} occurred while sending message', err, st);
      rethrow;
    }
  }

  WebsocketSubscription _subscribeToChatChannel() {
    return WebsocketSubscription(
      channel: 'ChatChannel',
      onData: (Json data) {
        final message = Message.fromJson(data);
        final updatedMessages = messageMap..[message.chatId] ??= [];
        updatedMessages[message.chatId]!.add(message);
        _subject.add(updatedMessages);
      },
    );
  }
}

extension MessageListExtension on List<Message> {
  List<Message> replace(Message message, {required Message next}) {
    final index = indexOf(message);
    if (index > -1) {
      replaceRange(index, index, [next]);
    }
    return this;
  }
}
