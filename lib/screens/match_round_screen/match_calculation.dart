import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';

class AvailablePlayersResult {
  final List<Player> benchedPlayers;
  final List<Player> players;

  AvailablePlayersResult({required this.players, required this.benchedPlayers});
}

class Team {
  final List<Player> players;

  Team({required this.players});
}

class CourtMatch {
  final int courtNumber;
  final Team team1;
  final Team team2;

  CourtMatch({required this.team1, required this.team2, required this.courtNumber});
}

class MatchCalculation {
  static AvailablePlayersResult getAvailablePlayersForRound(List<Player> players, String tournamentId, bool isFirstRound) {
    List<Player> playerTemp = [];

    if (isFirstRound) {
      playerTemp = _shufflePlayers(UnmodifiableListView(players));
    } else {
      playerTemp = List<Player>.from(players);
    }

    final playersSittingOver = _getPlayersSittingOver(UnmodifiableListView(playerTemp), tournamentId, isFirstRound);

    final playersForMatches = _getPlayersForMatches(UnmodifiableListView(playerTemp), UnmodifiableListView(playersSittingOver));

    return AvailablePlayersResult(players: playersForMatches, benchedPlayers: playersSittingOver);
  }

  static List<CourtMatch> getMatches(List<Player> players) {
    // Split players into courts of 4
    List<List<Player>> courts = [];
    for (int i = 0; i < players.length; i += 4) {
      // Use findBestPairing even for first round (defaults to balanced since no history)
      List<Player> group = players.sublist(i, i + 4); // Sort group for consistency
      courts.add(group);
    }

    for (var court in courts) {
      debugPrint('Court: $court');
    }

    // Create matches from courts
    List<CourtMatch> matches = [];
    int courtNumber = 1;
    for (final court in courts) {
      final Team team1 = Team(players: [court[0], court[2]]);
      final Team team2 = Team(players: [court[1], court[3]]);
      matches.add(CourtMatch(team1: team1, team2: team2, courtNumber: courtNumber++));
    }

    for (var match in matches) {
      debugPrint('Match on court ${match.courtNumber}: Team 1: ${match.team1.players}, Team 2: ${match.team2.players}');
    }

    return matches;
  }

  static List<Player> _shufflePlayers(UnmodifiableListView<Player> players) {
    final random = Random();
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);
    return shuffledPlayers;
  }

  static List<Player> _getPlayersSittingOver(UnmodifiableListView<Player> players, String tournamentId, bool isFirstRound) {
    final playersForSittingOverCalculation = List<Player>.from(players);
    final numberOfPeopleSittingOver = playersForSittingOverCalculation.length % 4;
    final List<Player> playersSittingOver = [];

    if (isFirstRound == false) {
      final tournament = Tournament.getById(tournamentId);
      if (tournament == null) {
        throw Exception('Tournament with id $tournamentId not found');
      }

      final Map<String, int> playersSittingOverStats = tournament.getPlayersSittingOverStats();
      playersForSittingOverCalculation.sort((a, b) {
        final aSittingOver = playersSittingOverStats[a.id] ?? 0;
        final bSittingOver = playersSittingOverStats[b.id] ?? 0;

        if (aSittingOver != bSittingOver) {
          return bSittingOver.compareTo(aSittingOver);
        } else {
          // Random order if same sitting over count
          return Random().nextInt(3) - 1;
        }
      });

      for (var p in playersForSittingOverCalculation) {
        debugPrint('Player ${p.name} has sat over ${playersSittingOverStats[p.id] ?? 0} times');
      }
    }

    for (var i = 0; i < numberOfPeopleSittingOver; i++) {
      final p = playersForSittingOverCalculation.removeLast();
      playersSittingOver.add(p);
    }

    return playersSittingOver;
  }

  static List<Player> _getPlayersForMatches(UnmodifiableListView<Player> players, UnmodifiableListView<Player> benchedPlayers) {
    final playersTemp = List<Player>.from(players);

    for (var p in benchedPlayers) {
      playersTemp.removeWhere((player) => player.id == p.id);
    }

    return playersTemp;
  }
}
