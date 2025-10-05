import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';

class MatchSummaryScreen extends StatefulWidget {
  static const String routerPath = "/matchSummary";
  const MatchSummaryScreen({super.key});

  @override
  State<MatchSummaryScreen> createState() => _MatchSummaryScreenState();
}

class _MatchSummaryScreenState extends State<MatchSummaryScreen> {
  MatchRound? _matchRound;
  List<Player> _players = [];
  final Set<String> _sittingOverPlayerIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_matchRound == null) {
      final String? matchRoundId = GoRouterState.of(context).extra as String?;
      if (matchRoundId == null) {
        debugPrint('**************matchRoundId can\'t be null');
        return;
      }

      _matchRound = MatchRound.getById(matchRoundId);

      if (_matchRound == null) {
        debugPrint('**************MatchRound can\'t be null');
        return;
      }

      _players = _matchRound!.getPlayersSortedByPoints();
      for (var player in _matchRound!.sittingOver) {
        _sittingOverPlayerIds.add(player.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match Summary')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.goNamed(TournamentSummaryScreen.routerPath, extra: _matchRound!.getTournament());
            },
            child: Text('Tournament Summary'),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed(HomeScreen.routerPath);
            },
            child: Text('Go to Home'),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];
              final isSittingOver = _sittingOverPlayerIds.contains(player.id);
              final pmp = PlayerMatchPoints.getByPlayerIdAndMatchRoundId(player.id, _matchRound!.id);
              return ListTile(
                title: Text(player.name),
                trailing: Text('${pmp.points} points'),
                tileColor: isSittingOver ? Colors.yellow[100] : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
