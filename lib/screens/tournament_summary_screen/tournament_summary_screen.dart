import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/mixins/vibrate_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/summary_list_tile.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class TournamentSummaryScreenRouteParams {
  final String tournamentId;
  final String? matchRoundId;

  TournamentSummaryScreenRouteParams({required this.tournamentId, this.matchRoundId});
}

class TournamentSummaryScreen extends StatefulWidget {
  static const String routerPath = "/tournamentSummary";
  const TournamentSummaryScreen({super.key});

  @override
  State<TournamentSummaryScreen> createState() => _TournamentSummaryScreenState();
}

class _TournamentSummaryScreenState extends State<TournamentSummaryScreen> with StorageMixin, VibrateMixin {
  Tournament? _tournament;
  MatchRound? _matchRound;
  List<Player> _players = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final params = getTournamentSummaryScreenRouteParams(context, throwErrorOnNull: true);
      _tournament = Tournament.getById(params!.tournamentId);

      if (params.matchRoundId != null) {
        _matchRound = MatchRound.getById(params.matchRoundId!);
      }

      _players = _tournament!.getPlayersSortedByTournamentPoints();
    }
  }

  Color? _getIndicatorColorForPlayerAtIndex(int index) {
    switch (index) {
      case 0:
        return AppColors.gold;
      case 1:
        return AppColors.silver;
      case 2:
        return AppColors.bronze;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      addTopPadding: true,
      showBackgroundImage: true,
      title: CustomTextTitle('Turnerings rangliste'),
      onHomeTap: () {
        vibrateShort();
        context.goNamed(HomeScreen.routerPath);
      },
      floatingActionButton: _tournament != null && _tournament!.isTournamentActive
          ? CustomFloatingActionButtonWithBottomSheetMenu(
              menuItems: [
                CustomFloatingActionButtonWithMenuModel(
                  text: 'Afslut turnering',
                  icon: Symbols.sports_volleyball,
                  onPressed: () async {
                    vibrateShort();
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
                if (_matchRound != null)
                  CustomFloatingActionButtonWithMenuModel(
                    text: 'Tilbage til runde rangliste',
                    icon: Symbols.social_leaderboard,
                    onPressed: () {
                      vibrateShort();
                      context.goNamed(MatchSummaryScreen.routerPath, extra: _matchRound!.id);
                    },
                  ),
                if (_matchRound != null)
                  CustomFloatingActionButtonWithMenuModel(
                    text: 'Opret runde ${_matchRound!.roundIndex + 1}',
                    icon: Symbols.play_arrow,
                    onPressed: () {
                      vibrateShort();
                      context.goNamed(MatchRoundScreen.routerPath, extra: _matchRound!.tournamentId);
                    },
                  ),
              ],
            )
          : null,
      body: ListView(
        children: [
          ListView.separated(
            separatorBuilder: (context, index) => ListViewSeparator(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];
              final ptp = PlayerTournamentPoints.getByPlayerIdAndTournamentId(player.id, _tournament!.id);
              return SummaryListTile(
                playerName: player.name,
                points: ptp.points,
                leadingIndicatorColor: _getIndicatorColorForPlayerAtIndex(index),
              );
            },
          ),
          const Gap(80),
        ],
      ),
    );
  }
}
