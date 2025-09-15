import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';

@Entity()
class MatchRound {
  @Id()
  int oid; // ObjectBox ID
  String? id;
  String? tournamentId;
  int roundIndex;
  @Backlink('matchRound')
  final matches = ToMany<Match>();
  final players = ToMany<Player>();
  final playerMatchPoints = ToMany<PlayerMatchPoints>();

  MatchRound({this.oid = 0, this.roundIndex = 0});
}
