import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';

class TournamentSummaryScreen extends StatefulWidget {
  static const String routerPath = "/tournamentSummary";
  const TournamentSummaryScreen({super.key});

  @override
  State<TournamentSummaryScreen> createState() => _TournamentSummaryScreenState();
}

class _TournamentSummaryScreenState extends State<TournamentSummaryScreen> {
  Tournament? _tournament;
  List<Player> _players = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final Tournament? tournament = GoRouterState.of(context).extra as Tournament?;
      if (tournament == null) {
        debugPrint('**************Tournament can\'t be null');
        return;
      }

      _tournament = tournament;
      _players = _tournament!.getPlayersSortedByTournamentPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tournament Ranking')),
      body: Column(
        children: [
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
              final ptp = PlayerTournamentPoints.getByPlayerIdAndTournamentId(player.id, _tournament!.id);
              return ListTile(title: Text(player.name), trailing: Text('${ptp.points} points'));
            },
          ),
        ],
      ),
    );
  }
}
