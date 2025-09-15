import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/administrate_match_round_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/benched_players.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';

class MatchRoundScreen extends StatefulWidget {
  static const String routerPath = "/matchRound";
  const MatchRoundScreen({super.key});

  @override
  State<MatchRoundScreen> createState() => _MatchRoundScreenState();
}

class _MatchRoundScreenState extends State<MatchRoundScreen> {
  Tournament? _tournament;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Tournament? tournament =
        GoRouterState.of(context).extra as Tournament?;

    if (tournament != null) {
      _tournament = tournament;
      debugPrint('********** didChangeDependencies tournamentId: $_tournament');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed(TournamentScreen.routerPath);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.groups),
            onPressed: () {
              AdministrateMatchRoundPlayersDialog.show(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          BenchedPlayers(players: []),
          MatchListTile(court: 1, team1: [], team2: []),
          MatchListTile(court: 2, team1: [], team2: []),
          MatchListTile(court: 3, team1: [], team2: []),
          MatchListTile(court: 4, team1: [], team2: []),
        ],
      ),
    );
  }
}
