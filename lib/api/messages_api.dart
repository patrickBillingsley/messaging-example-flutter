import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';

class MessagesApi extends BaseApi {
  Future<List<Message>> fetchMessagesFor(Chat chat) async {
    try {
      return await fetchList<Message>(
        '$baseApiUrl/chats/${chat.id}/messages',
        mapper: Message.fromJson,
      );
    } catch (err, st) {
      log.severe('${err.runtimeType} occurred while fetching messages', err, st);
      rethrow;
    }
  }

  Future<Message> sendMessage(Message message) async {
    try {
      return await post<Message>(
        '$baseApiUrl/chats/${message.chatId}/messages',
        mapper: Message.fromJson,
        body: {'sender_id': '1', 'body': message.body},
      );
    } catch (err, st) {
      log.severe('${err.runtimeType} occurred while sending message', err, st);
      rethrow;
    }
  }
}
