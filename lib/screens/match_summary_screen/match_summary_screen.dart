import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';

class MatchSummaryScreen extends StatefulWidget {
  static const String routerPath = "/matchSummary";
  const MatchSummaryScreen({super.key});

  @override
  State<MatchSummaryScreen> createState() => _MatchSummaryScreenState();
}

class _MatchSummaryScreenState extends State<MatchSummaryScreen> with StorageMixin {
  MatchRound? _matchRound;
  List<Player> _players = [];
  Set<String> _sittingOverPlayerIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_matchRound == null) {
      _matchRound = getMatchRoundById(context, throwErrorOnNull: true);

      _players = _matchRound!.getPlayersSortedByPoints();

      _sittingOverPlayerIds = _matchRound!.getPlayerIdsSittingOverAsSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rounde placering'), forceMaterialTransparency: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              context.goNamed(TournamentSummaryScreen.routerPath, extra: _matchRound!.id);
            },
            child: Text('Se Rangliste turnering'),
          ),
          Row(
            children: [
              Container(width: 20, height: 20, color: Colors.yellow[100]),
              Gap(8),
              Text('Sad over denne runde'),
            ],
          ),
          Text(
            'Runde tid: ${_matchRound!.roundTotalTimeUtc.inMinutes.remainder(60)} minutter, ${_matchRound!.roundTotalTimeUtc.inSeconds.remainder(60)} sekunder',
          ),

          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }
}
