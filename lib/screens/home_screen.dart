import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/screens/tournament_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routerPath = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Tilføj tournering')),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Turnering $index'),
                    onTap: () {
                      context.goNamed(TournamentScreen.routerPath);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
