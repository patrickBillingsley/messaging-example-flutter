import 'package:flutter/material.dart';

mixin Navigation<T extends Widget> {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => Navigation._navigatorKey;
  NavigatorState get navigator => Navigator.of(_navigatorKey.currentContext!);

  void show() {
    navigator.push(
      MaterialPageRoute(
        builder: (_) => this as T,
      ),
    );
  }

  void replaceStack() {
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => this as T,
      ),
    );
  }

  void pop() {
    navigator.pop();
  }
}
