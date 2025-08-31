import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
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
            ElevatedButton(
              onPressed: () {
                context.goNamed(TournamentScreen.routerPath);
              },
              child: Text('Tilføj tournering'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Turnering $index'),

                    onTap: () {
                      context.goNamed(
                        TournamentScreen.routerPath,
                        extra: Tournament(
                          id: 'test',
                          name: 'Test turnering',
                          players: [
                            Player(id: 'player1', name: 'Christian', points: 0),
                            Player(id: 'player2', name: 'Anders', points: 0),
                            Player(id: 'player3', name: 'Anders', points: 0),
                            Player(id: 'player4', name: 'Anders', points: 0),
                            Player(id: 'player5', name: 'Anders', points: 0),
                            Player(id: 'player6', name: 'Anders', points: 0),
                            Player(id: 'player7', name: 'Anders', points: 0),
                            Player(id: 'player8', name: 'Anders', points: 0),
                            Player(id: 'player9', name: 'Anders', points: 0),
                            Player(id: 'player10', name: 'Anders', points: 0),
                            Player(id: 'player11', name: 'Anders', points: 0),
                            Player(id: 'player12', name: 'Anders', points: 0),
                          ],
                          rounds: [],
                          pointPerMatch: 21,
                        ),
                      );
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
