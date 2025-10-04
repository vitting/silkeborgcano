import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';

class MatchSummaryScreen extends StatefulWidget {
  static const String routerPath = "/matchSummary";
  const MatchSummaryScreen({super.key});

  @override
  State<MatchSummaryScreen> createState() => _MatchSummaryScreenState();
}

class _MatchSummaryScreenState extends State<MatchSummaryScreen> {
  MatchRound? _matchRound;
  List<Player> _players = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_matchRound == null) {
      final MatchRound? matchRound = GoRouterState.of(context).extra as MatchRound?;
      if (matchRound == null) {
        debugPrint('**************MatchRound can\'t be null');
        return;
      }

      _matchRound = matchRound;
      final tournament = _matchRound!.getTournament();
      _players = tournament.getPlayersSortedByPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match Summary')),
      body: ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final player = _players[index];
          final pmp = _matchRound!.playerMatchPoints.firstWhere((p) => p.playerId == player.id);
          return ListTile(title: Text(player.name), trailing: Text('${pmp.points} points'));
        },
      ),
    );
  }
}
