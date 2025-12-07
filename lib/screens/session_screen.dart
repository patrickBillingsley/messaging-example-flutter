import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/bloc/session_bloc.dart';
import 'package:messaging_example/models/user.dart';
import 'package:messaging_example/widgets/animated_list_item.dart';
import 'package:messaging_example/widgets/keyboard_dismisser.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final StreamSubscription<User?> _currentUserSubscription;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? _emailError;
  String? _usernameError;

  bool login = true;

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  String get passwordConfirmation => _passwordConfirmationController.text.trim();
  String get username => _usernameController.text.trim();

  @override
  void initState() {
    super.initState();
    _currentUserSubscription = SessionBloc().currentUserStream.listen(_onCurrentUserChanged)..onError(_handleError);
  }

  @override
  void dispose() {
    _currentUserSubscription.cancel();
    super.dispose();
  }

  void _onCurrentUserChanged(User? user) {
    if (user != null) {}
  }

  void _handleError(Object err) {
    if (err is ApiException) {
      setState(() {
        _emailError = err.errors['email'];
        _usernameError = err.errors['username'];
      });
    }
  }

  Future<void> _login() async {
    if (login) {
      await SessionBloc().login(
        email: email,
        password: password,
      );
    } else {
      setState(() {
        login = true;
      });
    }
  }

  Future<void> _signup() async {
    if (login) {
      setState(() {
        login = false;
      });
    } else {
      await SessionBloc().signup(
        email: email,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _emailError,
                ),
              ),
              AnimatedListItem(
                child: login
                    ? null
                    : TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText: _usernameError,
                        ),
                      ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              AnimatedListItem(
                child: login
                    ? null
                    : TextField(
                        controller: _passwordConfirmationController,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                      ),
              ),
              const SizedBox(height: 48),
              FilledButton(
                onPressed: _login,
                style: FilledButton.styleFrom(
                  foregroundColor: login ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                  backgroundColor: login ? Theme.of(context).colorScheme.primary : Colors.transparent,
                ),
                child: const Text('Login'),
              ),
              FilledButton(
                onPressed: _signup,
                style: FilledButton.styleFrom(
                  foregroundColor: login ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: login ? Colors.transparent : Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
