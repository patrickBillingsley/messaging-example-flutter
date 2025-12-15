import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging_example/bloc/chats_bloc.dart';
import 'package:messaging_example/exceptions/server_exception.dart';
import 'package:messaging_example/mixin/navigation.dart';
import 'package:messaging_example/screens/chat_screen.dart';

class CreateChatScreen extends StatefulWidget with Navigation<CreateChatScreen> {
  const CreateChatScreen({super.key});

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> with Navigation {
  final GlobalKey<FormFieldState<String>> _roomNameKey = GlobalKey();

  String get roomName => _roomNameKey.currentState?.value ?? '';

  String? _roomNameError;

  Future<void> _createChat() async {
    try {
      final chat = await ChatsBloc().createChat(name: roomName);
      if (mounted) {
        pop();
      }
      ChatScreen(chat).show();
    } on ServerException catch (err) {
      setState(() {
        _roomNameError = err.userReadableErrors['name'];
      });
    }
  }

  void _onChanged(String name) {
    if (_roomNameKey.currentState?.hasError ?? false) {
      _roomNameKey.currentState?.reset();
    }

    _roomNameError = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            TextFormField(
              key: _roomNameKey,
              onChanged: _onChanged,
              autofocus: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              decoration: InputDecoration(
                labelText: 'Room Name',
                errorText: _roomNameError,
              ),
            ),
            Spacer(),
            FilledButton(
              onPressed: _createChat,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
