import 'package:flutter/material.dart';
import 'package:messaging_example/mixin/navigation.dart';
import 'package:messaging_example/screens/session_screen.dart';
import 'package:messaging_example/services/logging_service.dart';

void main() {
  LoggingService().initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget with Navigation {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: SessionScreen(),
    );
  }
}
