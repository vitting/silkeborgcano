import 'package:silkeborgcano/models/player.dart';

class Match {
  final List<Player> team1;
  final List<Player> team2;
  final int team1Score;
  final int team2Score;

  Match({
    required this.team1,
    required this.team2,
    this.team1Score = 0,
    this.team2Score = 0,
  });

  Match copyWith({int? team1Score, int? team2Score}) {
    return Match(
      team1: team1,
      team2: team2,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
    );
  }
}
