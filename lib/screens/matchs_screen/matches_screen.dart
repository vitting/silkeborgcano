import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  static const String routerPath = "/matches";
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matches Screen')),
      body: const Center(child: Text('This is the Matches Screen')),
    );
  }
}
