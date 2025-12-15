import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';

class MessagesApi extends BaseApi {
  Future<List<Message>> fetchMessagesFor(Chat chat) async {
    final (messages, _) = await fetchList<Message>(
      '$baseApiUrl/chats/${chat.id}/messages',
      mapper: Message.fromJson,
    );

    return messages;
  }

  Future<Message> sendMessage(Message message) async {
    final (persistedMessage, _) = await post<Message>(
      '$baseApiUrl/chats/${message.chatId}/messages',
      mapper: Message.fromJson,
      body: {
        'sender_id': '1',
        'body': message.body,
      },
    );

    return persistedMessage;
  }
}
