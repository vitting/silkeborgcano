import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/match_round_screen/administrate_match_round_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/benched_players.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_calculation.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';

class MatchRoundScreen extends StatefulWidget {
  static const String routerPath = "/matchRound";
  const MatchRoundScreen({super.key});

  @override
  State<MatchRoundScreen> createState() => _MatchRoundScreenState();
}

class _MatchRoundScreenState extends State<MatchRoundScreen> {
  Tournament? _tournament;
  MatchRound? _matchRound;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final Tournament? tournament = GoRouterState.of(context).extra as Tournament?;

      debugPrint('**************Tournament can\'t be null');

      if (tournament != null) {
        _tournament = tournament;

        _initMatchRound(tournament);
      }
    }
  }

  void _initMatchRound(Tournament tournament) {
    // If there are no rounds, create the first round
    if (tournament.rounds.isEmpty) {
      final m = MatchRound.createMatchRound(tournamentId: tournament.id, roundIndex: 1, players: tournament.players);
      _tournament!.addMatchRound(m);
      _matchRound = m;
      return;
    }

    final activeMatchRound = tournament.getActiveMatchRound();
    if (activeMatchRound != null) {
      _matchRound = activeMatchRound;
      return;
    } else {
      int nextRoundIndex = tournament.getLastRoundIndex() + 1;
      final m = MatchRound.createMatchRound(tournamentId: tournament.id, roundIndex: nextRoundIndex, players: tournament.players);
      _tournament!.addMatchRound(m);
      _matchRound = m;
      return;
    }
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
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Runde ${_matchRound?.roundIndex}'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed(TournamentScreen.routerPath, extra: _tournament);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.groups),
            onPressed: () {
              AdministrateMatchRoundPlayersDialog.show(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final players = _matchRound!.getPlayersSortedByPoints();
              debugPrint('********Players sorted by points: ${players.length}');

              final AvailablePlayersResult availablePlayersResult = MatchCalculation.getAvailablePlayersForFirstRound(players);
              final result = MatchCalculation.getMatches(availablePlayersResult.players);
              _matchRound!.setSittingOverPlayers(availablePlayersResult.benchedPlayers);
              _matchRound!.setMatches(result);
              setState(() {});
            },
            child: Text('Calculate matches'),
          ),

          ElevatedButton(
            onPressed: () {
              _matchRound?.startRound();
              context.goNamed(MatchesScreen.routerPath, extra: _matchRound);
            },
            child: Text('Start Runde ${_matchRound?.roundIndex}'),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: [
                if (_matchRound != null && _matchRound!.sittingOver.isNotEmpty) ...[
                  BenchedPlayers(players: _matchRound!.sittingOver),
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
