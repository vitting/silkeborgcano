import 'package:objectbox/objectbox.dart';

import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';

@Entity()
class Tournament {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String name;
  final players = ToMany<Player>();
  @Backlink('tournament')
  final rounds = ToMany<MatchRound>();
  int pointPerMatch;

  Tournament({
    this.oid = 0,
    this.id = '',
    this.name = '',
    this.pointPerMatch = 0,
  });

  @override
  String toString() {
    return 'Tournament(oid: $oid, id: $id, name: $name, pointPerMatch: $pointPerMatch)';
  }
}
