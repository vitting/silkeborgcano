import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';
import 'package:silkeborgcano/screens/match_summary_screen/summary_list_tile.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';
import 'package:silkeborgcano/widgets/screen_scaffold_title.dart';

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
    return ScreenScaffold(
      title: ScreenScaffoldTitle('Rounde placering'),
      floatingActionButton: CustomFloatingActionButton(
        tooltip: 'Gå til rangliste',
        icon: Symbols.crown,
        onPressed: () {
          context.goNamed(TournamentSummaryScreen.routerPath, extra: _matchRound!.id);
        },
      ),
      leading: SizedBox.shrink(),
      body: ListView(
        children: [
          Card(
            color: AppColors.deepSea1,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.xs),
              child: Column(
                children: [
                  Text(
                    'Tid: ${_matchRound!.roundTotalTimeUtc.inMinutes.remainder(60)}m:${_matchRound!.roundTotalTimeUtc.inSeconds.remainder(60)}s',
                    style: TextStyle(fontSize: 20, color: AppColors.textColor, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.sunburstYellow),
                      ),
                      Gap(8),
                      if (_sittingOverPlayerIds.isNotEmpty)
                        Text(
                          'Sad over denne runde',
                          style: TextStyle(fontSize: 20, color: AppColors.textColor, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Gap(AppSizes.xs),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => ListViewSeparator(),
            shrinkWrap: true,
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];
              final isSittingOver = _sittingOverPlayerIds.contains(player.id);
              final pmp = PlayerMatchPoints.getByPlayerIdAndMatchRoundId(player.id, _matchRound!.id);
              return SummaryListTile(playerName: player.name, isSittingOver: isSittingOver, points: pmp.points);
            },
          ),
        ],
      ),
    );
  }
}
