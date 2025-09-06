import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/tournament.dart';

@Entity()
class MatchRound {
  @Id()
  int oid; // ObjectBox ID
  int roundIndex;
  @Backlink('matchRound')
  final matches = ToMany<Match>();
  final tournament = ToOne<Tournament>();

  MatchRound({this.oid = 0, this.roundIndex = 0});
}
