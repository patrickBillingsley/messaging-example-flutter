import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_example/bloc/chats_bloc.dart';
import 'package:messaging_example/mixin/navigation.dart';
import 'package:messaging_example/models/chat.dart';
import 'package:messaging_example/screens/chat_screen.dart';
import 'package:messaging_example/screens/create_chat_screen.dart';

class HomeScreen extends StatefulWidget with Navigation {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription<List<Chat>> _chatsSubscription;

  late List<Chat>? _chats = ChatsBloc().chats;

  @override
  void initState() {
    super.initState();
    _chatsSubscription = ChatsBloc().stream.listen(_setChats);
    ChatsBloc().fetchChats();
  }

  @override
  void dispose() {
    _chatsSubscription.cancel();
    super.dispose();
  }

  void _setChats(List<Chat> chats) {
    setState(() {
      _chats = chats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chats = _chats;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: CreateChatScreen().show,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: chats == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  return ListTile(
                    onTap: ChatScreen(chat).show,
                    title: Text(chat.name ?? ''),
                  );
                },
              ),
      ),
    );
  }
}
