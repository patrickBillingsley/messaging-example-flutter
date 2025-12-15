import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/models/chat.dart';

class ChatsApi extends BaseApi {
  Future<List<Chat>> fetchChats() async {
    final (chats, _) = await fetchList<Chat>(
      '$baseApiUrl/chats',
      mapper: Chat.fromJson,
    );

    return chats;
  }

  Future<Chat> createChat(String name) async {
    final (chat, _) = await post<Chat>(
      '$baseApiUrl/chats',
      mapper: Chat.fromJson,
      body: {
        'name': name,
        'user_ids': [],
      },
    );

    return chat;
  }
}
