import 'package:objectbox/objectbox.dart' show Entity, Id;
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/objectbox.g.dart' hide Entity, Id;

@Entity()
class PlayerTournamentPoints {
  @Id()
  int oid; // ObjectBox ID
  String playerId;
  String tournamentId;
  int points;

  PlayerTournamentPoints({
    this.oid = 0,
    this.points = 0,
    this.playerId = '',
    this.tournamentId = '',
  });

  static void deleteAllByTournamentId(String tournamentId) {
    objectbox.store
        .box<PlayerTournamentPoints>()
        .query(PlayerTournamentPoints_.tournamentId.equals(tournamentId))
        .build()
        .remove();
  }

  static void deleteByPlayerId(String playerId) {
    objectbox.store
        .box<PlayerTournamentPoints>()
        .query(PlayerTournamentPoints_.playerId.equals(playerId))
        .build()
        .remove();
  }

  int save() {
    return objectbox.store.box<PlayerTournamentPoints>().put(this);
  }

  @override
  String toString() =>
      'PlayerTournamentPoints(oid: $oid, playerId: $playerId, points: $points)';
}
