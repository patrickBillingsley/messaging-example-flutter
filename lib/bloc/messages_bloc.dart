import 'package:messaging_example/api/messages_api.dart';
import 'package:messaging_example/api/websocket_api/websocket_api.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';
import 'package:rxdart/rxdart.dart';

class MessagesBloc {
  static MessagesBloc? _instance;
  final MessagesApi _api;

  factory MessagesBloc({MessagesApi? api}) {
    return _instance ??= MessagesBloc._(api);
  }

  MessagesBloc._([
    MessagesApi? api,
  ]) : _api = api ?? MessagesApi() {
    WebsocketApi().subscribeTo(channel: 'Chat');
  }

  final PublishSubject<List<Message>> _subject = PublishSubject();
  Stream<List<Message>> get stream => _subject.stream;

  Future<void> fetchMessagesFor(Chat chat) async {
    final messages = await _api.fetchMessagesFor(chat);
    _subject.add(messages);
  }
}
