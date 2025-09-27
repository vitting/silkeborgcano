import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:silkeborgcano/models/player.dart';

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

    return AvailablePlayersResult(players: shuffledPlayers, benchedPlayers: playersSittingOver);
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
