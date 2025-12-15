import 'package:messaging_example/models/message.dart';
import 'package:messaging_example/models/user.dart';
import 'package:messaging_example/types.dart';

class Chat {
  final String id;
  final String? name;
  final Message? lastMessage;
  final List<User> participants;

  const Chat({
    required this.id,
    this.name,
    this.lastMessage,
    this.participants = const [],
  });

  factory Chat.fromJson(Json json) {
    final lastMessage = json['last_message'];

    return Chat(
      id: '${json['id']}',
      name: json['name'],
      lastMessage: lastMessage != null ? Message.fromJson(lastMessage) : null,
    );
  }
}
