import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';

class AvailablePlayersResult {
  final List<Player> players;
  final List<Player> benchedPlayers;

  AvailablePlayersResult({required this.players, required this.benchedPlayers});
}

class Team {
  final List<Player> players;

  Team({required this.players});
}

class CourtMatch {
  final Team team1;
  final Team team2;
  final int courtNumber;

  CourtMatch({required this.team1, required this.team2, required this.courtNumber});
}

class MatchCalculation {
  static AvailablePlayersResult getAvailablePlayersForFirstRound(List<Player> players) {
    final shuffledPlayers = _shufflePlayers(UnmodifiableListView(players));

    final (:playersSittingOver, :playersForMatches) = _getPlayersSittingOver(UnmodifiableListView(shuffledPlayers));

    return AvailablePlayersResult(players: playersForMatches, benchedPlayers: playersSittingOver);
  }

  static List<Player> _shufflePlayers(UnmodifiableListView<Player> players) {
    final random = Random();
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);
    return shuffledPlayers;
  }

  static ({List<Player> playersSittingOver, List<Player> playersForMatches}) _getPlayersSittingOver(
    UnmodifiableListView<Player> players,
  ) {
    final playersTemp = List<Player>.from(players);
    final numberOfPeopleSittingOver = playersTemp.length % 4;
    final List<Player> playersSittingOver = [];

    for (var i = 0; i < numberOfPeopleSittingOver; i++) {
      final p = playersTemp.removeLast();
      playersSittingOver.add(p);
    }

    return (playersSittingOver: playersSittingOver, playersForMatches: playersTemp);
  }

  static AvailablePlayersResult getAvailablePlayersForRound(List<Player> players, String tournamentId) {
    final playersTemp = List<Player>.from(players);
    final tournament = Tournament.getById(tournamentId);
    if (tournament == null) {
      throw Exception('Tournament with id $tournamentId not found');
    }

    final Map<String, int> playersSittingOverStats = tournament.getPlayersSittingOverStats();
    playersTemp.sort((a, b) {
      final aSittingOver = playersSittingOverStats[a.id] ?? 0;
      final bSittingOver = playersSittingOverStats[b.id] ?? 0;

      if (aSittingOver != bSittingOver) {
        return bSittingOver.compareTo(aSittingOver);
      } else {
        //
        return Random().nextInt(3) - 1; // Random order if same sitting over count
      }
    });

    for (var p in playersTemp) {
      debugPrint('Player ${p.name} has sat over ${playersSittingOverStats[p.id] ?? 0} times');
    }

    final (:playersSittingOver, :playersForMatches) = _getPlayersSittingOver(UnmodifiableListView(playersTemp));

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
}
