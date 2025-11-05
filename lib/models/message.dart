import 'package:messaging_example/bloc/messages_bloc.dart';

class Message {
  final String? id;
  final String? senderId;
  final String chatId;
  final String body;

  const Message({
    this.id,
    this.senderId,
    required this.chatId,
    required this.body,
  });

  factory Message.fromJson(Map<String, Object?> json) {
    return Message(
      id: '${json['id']}',
      senderId: '${json['user_id']}',
      chatId: '${json['chat_id']}',
      body: json['body'] as String,
    );
  }

  Future<Message> send() => MessagesBloc().send(this);
}
