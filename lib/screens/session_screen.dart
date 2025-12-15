import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging_example/bloc/session_bloc.dart';
import 'package:messaging_example/exceptions/server_exception.dart';
import 'package:messaging_example/models/user.dart';
import 'package:messaging_example/screens/home_screen.dart';
import 'package:messaging_example/widgets/animated_list_item.dart';
import 'package:messaging_example/widgets/keyboard_dismisser.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final StreamSubscription<User?> _currentUserSubscription;

  final _form = GlobalKey<FormState>();
  final Map<String, GlobalKey<FormFieldState<String>>> _fields = {
    'email': GlobalKey(),
    'username': GlobalKey(),
    'password': GlobalKey(),
    'password_confirmation': GlobalKey(),
  };

  Map<String, String?> _errors = {};

  bool _showSignupFields = false;

  String valueFor(String field) => _fields[field]?.currentState?.value ?? '';

  @override
  void initState() {
    super.initState();
    _currentUserSubscription = SessionBloc().currentUserStream.listen(
      _onCurrentUserChanged,
      onError: _handleError,
    );
  }

  @override
  void dispose() {
    _currentUserSubscription.cancel();
    super.dispose();
  }

  void _onCurrentUserChanged(User? user) {
    if (user != null) {
      HomeScreen().show();
    }
  }

  void _handleError(Object err) {
    if (err is ServerException) {
      setState(() {
        _errors['email'] = err.userReadableErrors['email'];
        _errors['username'] = err.userReadableErrors['username'];
        _errors['password'] = err.userReadableErrors['password'];
        _errors['password_confirmation'] = err.userReadableErrors['password_confirmation'];
      });
    }
  }

  Future<void> _login() async {
    if (_form.currentState!.validate()) {
      await SessionBloc().login(
        email: valueFor('email'),
        password: valueFor('password'),
      );
    }
  }

  void _showLogin() {
    if (!_showSignupFields) return;

    setState(() {
      _showSignupFields = false;
      _form.currentState?.reset();
      _errors = {};
    });
  }

  Future<void> _signup() async {
    if (_form.currentState!.validate()) {
      await SessionBloc().signup(
        email: valueFor('email'),
        username: valueFor('username'),
        password: valueFor('password'),
        passwordConfirmation: valueFor('passwordConfirmation'),
      );
    }
  }

  void _showSignup() {
    if (_showSignupFields) return;

    setState(() {
      _showSignupFields = true;
      _form.currentState?.reset();
      _errors = {};
    });
  }

  void _onChanged(String? value, String fieldKey) {
    if (_fields[fieldKey]?.currentState?.errorText != null) {
      _fields[fieldKey]?.currentState?.reset();
    }

    _clearError(fieldKey);
  }

  void _clearError(String key) {
    if (!mounted) return;

    if (_errors[key] != null) {
      setState(() {
        _errors[key] = null;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must provide an email.';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Must provide a valid email.';
    }

    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must provide a username.';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters long.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must provide a password';
    }

    if (_showSignupFields && valueFor('password') != valueFor('passwordConfirmation')) {
      return 'Passwords must match';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        key: _fields['email'],
                        validator: _validateEmail,
                        onChanged: (value) => _onChanged(value, 'email'),
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(30),
                          FilteringTextInputFormatter.deny(RegExp(r'\s+')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _errors['email'],
                        ),
                      ),
                      AnimatedListItem(
                        visible: _showSignupFields,
                        child: TextFormField(
                          key: _fields['username'],
                          validator: _validateUsername,
                          onChanged: (value) => _onChanged(value, 'username'),
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^[A-Za-z0-9_!@$+]+$'),
                              replacementString: valueFor('username'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Username',
                            errorText: _errors['username'],
                          ),
                        ),
                      ),
                      TextFormField(
                        key: _fields['password'],
                        validator: _validatePassword,
                        onChanged: (value) => _onChanged(value, 'password'),
                        autocorrect: false,
                        enableSuggestions: false,
                        // obscureText: true,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                          FilteringTextInputFormatter.deny(RegExp(r'\s+')),
                        ],
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      AnimatedListItem(
                        visible: _showSignupFields,
                        child: TextFormField(
                          key: _fields['password_confirmation'],
                          validator: _validatePassword,
                          onChanged: (value) => _onChanged(value, 'password_confirmation'),
                          autocorrect: false,
                          enableSuggestions: false,
                          // obscureText: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                            FilteringTextInputFormatter.deny(RegExp(r'\s+')),
                          ],
                          decoration: InputDecoration(labelText: 'Confirm Password'),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      FilledButton(
                        onPressed: _showSignupFields ? _showLogin : _login,
                        style: FilledButton.styleFrom(
                          foregroundColor: _showSignupFields ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: _showSignupFields ? Colors.transparent : Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text('Login'),
                      ),
                      FilledButton(
                        onPressed: _showSignupFields ? _signup : _showSignup,
                        style: FilledButton.styleFrom(
                          foregroundColor: _showSignupFields ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                          backgroundColor: _showSignupFields ? Theme.of(context).colorScheme.primary : Colors.transparent,
                        ),
                        child: const Text('Signup'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
