import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/administrate_match_round_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/benched_players.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:uuid/uuid.dart';

class MatchRoundScreen extends StatefulWidget {
  static const String routerPath = "/matchRound";
  const MatchRoundScreen({super.key});

  @override
  State<MatchRoundScreen> createState() => _MatchRoundScreenState();
}

class _MatchRoundScreenState extends State<MatchRoundScreen> {
  Tournament? _tournament;
  MatchRound? _matchRound;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final Tournament? tournament =
          GoRouterState.of(context).extra as Tournament?;

      debugPrint('**************Tournament can\'t be null');

      if (tournament != null) {
        _tournament = tournament;

        int currentNumberOfMatches = _tournament!.rounds.length;
        _matchRound = MatchRound(
          id: Uuid().v4(),
          tournamentId: _tournament!.id,
          roundIndex: ++currentNumberOfMatches,
        );

        debugPrint(
          '********** didChangeDependencies tournamentId: $_tournament',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Runde ${_matchRound?.roundIndex}'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed(TournamentScreen.routerPath, extra: _tournament);
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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Start Runde ${_matchRound?.roundIndex}'),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: [
                BenchedPlayers(players: []),
                MatchListTile(court: 1, team1: [], team2: []),
                MatchListTile(court: 2, team1: [], team2: []),
                MatchListTile(court: 3, team1: [], team2: []),
                MatchListTile(court: 4, team1: [], team2: []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
