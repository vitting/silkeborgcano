import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/administrate_match_round_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/benched_players.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:uuid/uuid.dart';

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

        if (_tournament!.rounds.isNotEmpty) {
          _matchRound = _tournament!.rounds.last;
          debugPrint('********** didChangeDependencies tournamentId: $_tournament, matchRoundId: ${_matchRound?.id}');
          return;
        }

        int currentNumberOfMatches = _tournament!.rounds.length;
        _matchRound = MatchRound(id: Uuid().v4(), tournamentId: _tournament!.id, roundIndex: ++currentNumberOfMatches);

        _matchRound!.save();

        _matchRound!.setPlayers(_tournament!.players.toList());

        _tournament!.addMatchRound(_matchRound!);

        debugPrint('********** didChangeDependencies tournamentId: $_tournament');
      }
    }
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

              // Randomize players for first round
              final random = Random();
              final shuffledPlayers = List<Player>.from(players)..shuffle(random);

              // Determine players sitting over this round
              final numberOfPeopleSittingOver = shuffledPlayers.length % 4;
              final List<Player> playersSittingOver = [];
              for (var i = 0; i < numberOfPeopleSittingOver; i++) {
                final p = shuffledPlayers.removeLast();
                playersSittingOver.add(p);
              }

              for (var element in shuffledPlayers) {
                debugPrint('Shuffled players: $element');
              }

              for (var element in playersSittingOver) {
                debugPrint('Sitting over players: $element');
              }

              // Split players into courts of 4
              List<List<Player>> courts = [];
              for (int i = 0; i < shuffledPlayers.length; i += 4) {
                // Use findBestPairing even for first round (defaults to balanced since no history)
                List<Player> group = shuffledPlayers.sublist(i, i + 4); // Sort group for consistency
                courts.add(group);
              }

              for (var court in courts) {
                debugPrint('Court: $court');
              }

              // Create matches from courts
              List<List<List<Player>>> matches = [];
              for (final court in courts) {
                List<List<Player>> match = [];
                final team1 = [court[0], court[2]];
                final team2 = [court[1], court[3]];
                match.add(team1);
                match.add(team2);
                matches.add(match);
              }

              for (var match in matches) {
                for (var team in match) {
                  debugPrint('Team: $team');
                }
              }
            },
            child: Text('Calculate matches'),
          ),

          ElevatedButton(onPressed: () {}, child: Text('Start Runde ${_matchRound?.roundIndex}')),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: [
                // BenchedPlayers(players: []),
                // MatchListTile(court: 1, team1: [], team2: []),
                // MatchListTile(court: 2, team1: [], team2: []),
                // MatchListTile(court: 3, team1: [], team2: []),
                // MatchListTile(court: 4, team1: [], team2: []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
