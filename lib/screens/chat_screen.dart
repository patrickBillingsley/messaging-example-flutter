import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_example/bloc/messages_bloc.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final StreamSubscription<List<Message>> _messagesSubscription;

  List<Message>? _messages;
  List<Message> get messages => _messages ?? [];

  @override
  void initState() {
    super.initState();
    _messagesSubscription = MessagesBloc().stream.listen(_setMessages);
    MessagesBloc().fetchMessagesFor(Chat(id: '1'));
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    super.dispose();
  }

  void _setMessages(List<Message> messages) {
    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ...messages.map((message) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(message.body),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
