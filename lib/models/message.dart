class Message {
  final String? id;
  final String? senderId;
  final String body;

  const Message({
    this.id,
    this.senderId,
    required this.body,
  });

  factory Message.fromJson(Map<String, Object?> json) {
    return Message(
      id: '${json['id']}',
      senderId: '${json['user_id']}',
      body: json['body'] as String,
    );
  }
}
