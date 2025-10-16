import 'package:objectbox/objectbox.dart' show Entity, Id;
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/objectbox.g.dart' hide Entity, Id;

@Entity()
class PlayerMatchPoints {
  @Id()
  int oid; // ObjectBox ID
  String playerId;
  String matchRoundId;
  int points;
  bool sittingOver;

  PlayerMatchPoints({this.oid = 0, this.points = 0, this.playerId = '', this.matchRoundId = '', this.sittingOver = false});

  factory PlayerMatchPoints.createPlayerMatchPoints({required String playerId, required String matchRoundId}) {
    return PlayerMatchPoints(playerId: playerId, matchRoundId: matchRoundId, points: 0, sittingOver: false);
  }

  static PlayerMatchPoints getByPlayerIdAndMatchRoundId(String playerId, String matchRoundId) {
    return objectbox.store
        .box<PlayerMatchPoints>()
        .query(PlayerMatchPoints_.playerId.equals(playerId) & PlayerMatchPoints_.matchRoundId.equals(matchRoundId))
        .build()
        .findFirst()!;
  }

  static void deleteAllByMatchRoundId(String matchRoundId) {
    objectbox.store.box<PlayerMatchPoints>().query(PlayerMatchPoints_.matchRoundId.equals(matchRoundId)).build().remove();
  }

  static List<PlayerMatchPoints> getSortedByPoints(String matchRoundId, {bool descending = true}) {
    return objectbox.store
        .box<PlayerMatchPoints>()
        .query(PlayerMatchPoints_.matchRoundId.equals(matchRoundId))
        .order(PlayerMatchPoints_.points, flags: descending ? Order.descending : 0)
        .build()
        .find();
  }

  int save() {
    return objectbox.store.box<PlayerMatchPoints>().put(this);
  }

  void updatePoints(int points) {
    this.points = points;
    objectbox.store.box<PlayerMatchPoints>().put(this);
  }

  @override
  String toString() {
    return 'PlayerMatchPoints(oid: $oid, playerId: $playerId, matchRoundId: $matchRoundId, points: $points, sittingOver: $sittingOver)';
  }
}
