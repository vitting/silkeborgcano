import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';

class Tournament {
  final List<Player> players;
  final List<MatchRound> rounds;
  final int pointPerMatch;

  Tournament({
    required this.players,
    required this.rounds,
    required this.pointPerMatch,
  });

  Tournament copyWith({
    List<Player>? players,
    List<MatchRound>? rounds,
    int? pointPerMatch,
  }) {
    return Tournament(
      players: players ?? this.players,
      rounds: rounds ?? this.rounds,
      pointPerMatch: pointPerMatch ?? this.pointPerMatch,
    );
  }
}
