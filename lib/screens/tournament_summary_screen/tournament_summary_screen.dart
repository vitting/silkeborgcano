import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/summary_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

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
    return ScreenScaffold(
      title: Text('Rangliste'),
      onHomeTap: () {
        context.goNamed(HomeScreen.routerPath);
      },
      floatingActionButton: CustomFloatingActionButton(
        icon: Symbols.play_circle,
        tooltip: 'Næste runde',
        onPressed: () {
          context.goNamed(MatchRoundScreen.routerPath, extra: _tournament!.id);
        },
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              context.goNamed(MatchSummaryScreen.routerPath, extra: _matchRound!.id);
            },
            child: Text('Match Summary'),
          ),
          ListView.separated(
            separatorBuilder: (context, index) => ListViewSeparator(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];
              final ptp = PlayerTournamentPoints.getByPlayerIdAndTournamentId(player.id, _tournament!.id);
              return SummaryListTile(playerName: player.name, points: ptp.points);
            },
          ),
        ],
      ),
    );
  }
}
