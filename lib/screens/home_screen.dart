import 'package:flutter/material.dart';
import 'package:messaging_example/mixin/navigation.dart';

class HomeScreen extends StatefulWidget with Navigation {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}
