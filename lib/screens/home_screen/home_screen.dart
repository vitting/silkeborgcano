import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routerPath = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Silkeborg Cano'),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: Icon(Icons.groups),
            onPressed: () {
              AdministratePlayersDialog.show(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                objectbox.store.box<Tournament>().removeAll();
                objectbox.store.box<Player>().removeAll();
              },
              child: Text('Delete all data'),
            ),
            ElevatedButton(
              onPressed: () {
                context.goNamed(TournamentScreen.routerPath);
              },
              child: Text('Tilføj tournering'),
            ),
            StreamBuilder(
              stream: Tournament.listOfAllTournamentsAsStream,
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }

                final data = asyncSnapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tournament = data[index];
                      return ListTile(
                        title: Text(tournament.name),

                        onTap: () {
                          final matchRound = tournament.getCurrentMatchRound();

                          debugPrint('ACtive mach round: $matchRound');

                          if (matchRound != null) {
                            if (matchRound.active) {
                              context.goNamed(MatchesScreen.routerPath, extra: matchRound.id);
                            } else {
                              context.goNamed(MatchRoundScreen.routerPath, extra: tournament.id);
                            }
                          } else {
                            context.goNamed(TournamentScreen.routerPath, extra: tournament.id);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
