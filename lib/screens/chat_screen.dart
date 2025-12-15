import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_example/bloc/messages_bloc.dart';
import 'package:messaging_example/mixin/navigation.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';

class ChatScreen extends StatefulWidget with Navigation<ChatScreen> {
  final Chat chat;

  const ChatScreen(
    this.chat, {
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final StreamSubscription<List<Message>?> _messagesSubscription;

  final TextEditingController _textController = TextEditingController();

  List<Message>? _messages;
  List<Message> get messages => List.from(_messages ?? []);

  @override
  void initState() {
    super.initState();
    _messagesSubscription = MessagesBloc().streamFor(widget.chat).listen(_setMessages);
    MessagesBloc().fetchMessagesFor(widget.chat);
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  void _setMessages(List<Message>? messages) {
    setState(() {
      _messages = messages;
    });
  }

  Future<void> _sendMessage(String body) async {
    final message = Message(chatId: widget.chat.id, senderId: '1', body: body);
    await message.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name ?? ''),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  return Card(
                    color: message.isPending ? Colors.cyanAccent.shade100 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(message.body),
                    ),
                  );
                },
              ),
            ),

            TextField(
              controller: _textController,
              onSubmitted: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
