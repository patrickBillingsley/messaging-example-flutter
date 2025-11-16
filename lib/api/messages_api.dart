import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';

class MessagesApi with Logger {
  static String get baseApiUrl => 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/api/v1';

  Future<List<Message>> fetchMessagesFor(Chat chat) async {
    try {
      final url = Uri.parse('$baseApiUrl/chats/${chat.id}/messages');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      final data = List<Map<String, Object?>>.from(jsonDecode(response.body));

      return data.map(Message.fromJson).toList();
    } catch (err, st) {
      log.severe('${err.runtimeType} occurred while fetching messages', err, st);
      rethrow;
    }
  }

  Future<Message> sendMessage(Message message) async {
    try {
      final url = Uri.parse('$baseApiUrl/chats/${message.chatId}/messages');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sender_id': '1', 'body': message.body}),
      );
      final data = Map<String, Object?>.from(jsonDecode(response.body));

      return Message.fromJson(data);
    } catch (err, st) {
      log.severe('${err.runtimeType} occurred while sending message', err, st);
      rethrow;
    }
  }
}
