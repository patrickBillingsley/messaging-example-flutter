import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';

class MessagesApi {
  static const String baseApiUrl = 'http://10.0.2.2:3000/api/v1';

  Future<List<Message>> fetchMessagesFor(Chat chat) async {
    try {
      final url = Uri.parse('$baseApiUrl/chats/${chat.id}/messages');
      final response = await http.get(url);
      final data = List<Map<String, Object?>>.from(jsonDecode(response.body));

      return data.map(Message.fromJson).toList();
    } catch (err, st) {
      print('$err\n$st');
      return Future.error(err, st);
    }
  }
}
