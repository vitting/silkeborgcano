import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/summary_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
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
      title: Text('Turnerings rangliste'),
      onHomeTap: () {
        context.goNamed(HomeScreen.routerPath);
      },
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
            text: 'Tilbage til runde rangliste',
            icon: Symbols.social_leaderboard,
            onPressed: () {
              context.goNamed(MatchSummaryScreen.routerPath, extra: _matchRound!.id);
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
              return SummaryListTile(playerName: player.name, points: ptp.points);
            },
          ),
        ],
      ),
    );
  }
}
