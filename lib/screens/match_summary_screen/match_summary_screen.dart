import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_info_card.dart';
import 'package:silkeborgcano/screens/match_summary_screen/summary_list_tile.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
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
      floatingActionButton: CustomFloatingActionButtonWithBottomSheetMenu(
        menuItems: [
          CustomFloatingActionButtonWithMenuModel(
            text: 'Afslut turnering',
            icon: Symbols.sports_volleyball,
            onPressed: () async {
              final result = await YesNoDialog.show(
                context,
                title: 'Afslut turnering',
                body: 'Er du sikker på at du vil afslutte turneringen?',
                yesButtonText: 'Ja',
                noButtonText: 'Nej',
              );

              if (result != null && result) {
                final tournament = _matchRound!.getTournament();
                tournament.endTournament();

                if (context.mounted) {
                  context.goNamed(HomeScreen.routerPath);
                }
              }
            },
          ),
          CustomFloatingActionButtonWithMenuModel(
            text: 'Gå til rangliste',
            icon: Symbols.crown,
            onPressed: () {
              context.goNamed(TournamentSummaryScreen.routerPath, extra: _matchRound!.id);
            },
          ),
          CustomFloatingActionButtonWithMenuModel(
            text: 'Opret runde ${_matchRound!.roundIndex + 1}',
            icon: Symbols.play_arrow,
            onPressed: () {
              context.goNamed(MatchRoundScreen.routerPath, extra: _matchRound!.tournamentId);
            },
          ),
        ],
      ),
      leading: SizedBox.shrink(),
      body: ListView(
        children: [
          MatchSummaryInfoCard(
            roundIndex: _matchRound!.roundIndex,
            matchTime:
                'Tid: ${_matchRound!.roundTotalTimeUtc.inMinutes.remainder(60)}m ${_matchRound!.roundTotalTimeUtc.inSeconds.remainder(60)}s',
            showSittingOverIndicator: _sittingOverPlayerIds.isNotEmpty,
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
