import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';

class Tournament {
  final String id;
  final String name;
  final List<Player> players;
  final List<MatchRound> rounds;
  final int pointPerMatch;

  Tournament({
    required this.id,
    required this.name,
    required this.players,
    required this.rounds,
    required this.pointPerMatch,
  });

  Tournament copyWith({
    List<Player>? players,
    List<MatchRound>? rounds,
    int? pointPerMatch,
    String? name,
  }) {
    return Tournament(
      id: id,
      name: name ?? this.name,
      players: players ?? this.players,
      rounds: rounds ?? this.rounds,
      pointPerMatch: pointPerMatch ?? this.pointPerMatch,
    );
  }
}
