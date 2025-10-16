import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/match_round_screen/administrate_match_round_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/benched_players_tile.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_calculation.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';
import 'package:silkeborgcano/widgets/screen_scaffold_title.dart';

class MatchRoundScreen extends StatefulWidget {
  static const String routerPath = "/matchRound";

  const MatchRoundScreen({super.key});

  @override
  State<MatchRoundScreen> createState() => _MatchRoundScreenState();
}

class _MatchRoundScreenState extends State<MatchRoundScreen> with StorageMixin {
  MatchRound? _matchRound;
  Tournament? _tournament;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      _tournament = getTournamentById(context, throwErrorOnNull: true);

      if (_tournament!.currentRoundId.isNotEmpty) {
        _matchRound = _tournament!.getCurrentMatchRound();
      } else {
        _initMatchRound(_tournament!);
      }
    }
  }

  void _initMatchRound(Tournament tournament) {
    // If there are no rounds, create the first round
    if (tournament.rounds.isEmpty) {
      final m = MatchRound.createMatchRound(tournamentId: tournament.id, roundIndex: 1, players: tournament.players);
      _tournament!.addMatchRound(m);
      _matchRound = m;
      _calculateMatches(true);
      return;
    }

    final currentMatchRound = tournament.getCurrentMatchRound();
    // If there is an active round, use that
    // If there is no active round, create a new round
    if (currentMatchRound != null) {
      _matchRound = currentMatchRound;
      return;
    } else {
      int nextRoundIndex = tournament.getLastRoundIndex() + 1;
      final m = MatchRound.createMatchRound(tournamentId: tournament.id, roundIndex: nextRoundIndex, players: tournament.players);
      _tournament!.addMatchRound(m);
      _matchRound = m;
      _calculateMatches(false);
      return;
    }
  }

  void _calculateMatches(bool isFirstRound) {
    final players = _tournament!.getPlayersSortedByTournamentPoints();
    debugPrint('********Players sorted by points: ${players.length}');

    final AvailablePlayersResult availablePlayersResult = MatchCalculation.getAvailablePlayersForRound(
      players,
      _tournament!.id,
      isFirstRound,
    );
    _matchRound!.setSittingOverPlayers(availablePlayersResult.benchedPlayers);

    final matches = MatchCalculation.getMatches(availablePlayersResult.players);
    _matchRound!.setMatches(matches);
  }

  Widget _matches() {
    if (_matchRound == null) {
      return SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final m = _matchRound!.matches[index];
        return MatchListTile(court: m.courtNumber, team1: m.team1, team2: m.team2);
      },
      separatorBuilder: (context, index) {
        return Gap(8);
      },
      itemCount: _matchRound!.matches.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      floatingActionButton: CustomFloatingActionButtonWithBottomSheetMenu(
        menuItems: [
          CustomFloatingActionButtonWithMenuModel(
            text: 'Start runde ${_matchRound?.roundIndex ?? ''}',
            icon: Symbols.sports_volleyball,
            onPressed: () {
              if (_matchRound != null) {
                if (_matchRound!.roundIndex == 1) {
                  _tournament!.startTournament();
                }

                _matchRound!.startRound();
                context.goNamed(MatchesScreen.routerPath, extra: _matchRound!.id);
              }
            },
          ),
          CustomFloatingActionButtonWithMenuModel(
            text: 'Administrer spillere',
            icon: Icons.groups,
            onPressed: () {
              if (_matchRound != null) {
                AdministrateMatchRoundPlayersDialog.show(context);
              }
            },
          ),
        ],
      ),
      title: ScreenScaffoldTitle('Runde ${_matchRound?.roundIndex ?? ''}'),
      leading: CustomIconButton(
        icon: Symbols.home,
        onPressed: () {
          context.goNamed(TournamentScreen.routerPath, extra: _tournament!.id);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: [
                if (_matchRound != null && _matchRound!.sittingOver.isNotEmpty) ...[
                  BenchedPlayersTile(players: _matchRound!.sittingOver),
                  Gap(8),
                ],
                _matches(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
