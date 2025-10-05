import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';

class TournamentSummaryScreen extends StatefulWidget {
  static const String routerPath = "/tournamentSummary";
  const TournamentSummaryScreen({super.key});

  @override
  State<TournamentSummaryScreen> createState() => _TournamentSummaryScreenState();
}

class _TournamentSummaryScreenState extends State<TournamentSummaryScreen> with StorageMixin {
  Tournament? _tournament;
  MatchRound? _matchRound;
  List<Player> _players = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      _matchRound = getMatchRoundById(context, throwErrorOnNull: true);
      _tournament = _matchRound!.getTournament();
      _players = _tournament!.getPlayersSortedByTournamentPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rangliste'), forceMaterialTransparency: true),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.goNamed(HomeScreen.routerPath);
            },
            child: Text('Go to Home'),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed(MatchSummaryScreen.routerPath, extra: _matchRound!.id);
            },
            child: Text('Match Summary'),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed(MatchRoundScreen.routerPath, extra: _tournament!.id);
            },
            child: Text('Ny runde'),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                final ptp = PlayerTournamentPoints.getByPlayerIdAndTournamentId(player.id, _tournament!.id);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(player.name), Text('${ptp.points} points')],
                );
                // return ListTile(title: Text(player.name), trailing: Text('${ptp.points} points'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
