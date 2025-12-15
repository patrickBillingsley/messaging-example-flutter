import 'package:messaging_example/api/chats_api.dart';
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:rxdart/rxdart.dart';

class ChatsBloc with Logger {
  static ChatsBloc? _instance;
  final ChatsApi _api;

  factory ChatsBloc({ChatsApi? api}) {
    return _instance ??= ChatsBloc._(api);
  }

  ChatsBloc._([
    ChatsApi? api,
  ]) : _api = api ?? ChatsApi();

  final BehaviorSubject<List<Chat>> _subject = BehaviorSubject.seeded([]);
  Stream<List<Chat>> get stream => _subject.stream;
  List<Chat> get chats => List.from(_subject.value);

  Future<void> fetchChats() async {
    try {
      final chats = await _api.fetchChats();
      _subject.add(chats);
    } catch (err, st) {
      log.warning('${err.runtimeType} occurred while fetching chats.', err, st);
      _subject.addError(err);
    }
  }

  Future<Chat> createChat({required String name}) async {
    try {
      final chat = await _api.createChat(name);
      _subject.add(chats..add(chat));

      return chat;
    } catch (err, st) {
      log.warning('${err.runtimeType} occurred while creating chat.', err, st);
      _subject.addError(err);
      rethrow;
    }
  }
}
