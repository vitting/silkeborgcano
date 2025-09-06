import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';

@Entity()
class Match {
  @Id()
  int oid; // ObjectBox ID
  String id;
  final team1 = ToMany<Player>();
  final team2 = ToMany<Player>();
  int team1Score;
  int team2Score;
  final matchRound = ToOne<MatchRound>();

  Match({this.oid = 0, this.id = '', this.team1Score = 0, this.team2Score = 0});
}
