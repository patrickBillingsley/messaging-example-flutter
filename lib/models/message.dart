import 'package:messaging_example/bloc/messages_bloc.dart';
import 'package:messaging_example/types.dart';

class Message {
  final String? id;
  final String senderId;
  final String chatId;
  final DateTime createdAt;
  final String body;

  /// [createdAt] defaults to `DateTime.now()`
  Message({
    this.id,
    required this.senderId,
    required this.chatId,
    DateTime? createdAt,
    required this.body,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Message.fromJson(Json json) {
    return Message(
      id: '${json['id']}',
      senderId: '${json['user_id']}',
      chatId: '${json['chat_id']}',
      createdAt: DateTime.parse(json['created_at']),
      body: json['body'],
    );
  }

  bool get isPending => id == null;

  Future<Message> send() => MessagesBloc().send(this);
}
