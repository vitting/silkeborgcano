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

  PlayerTournamentPoints({this.oid = 0, this.points = 0, this.playerId = '', this.tournamentId = ''});

  factory PlayerTournamentPoints.createPlayerTournamentPoints({required String playerId, required String tournamentId}) {
    return PlayerTournamentPoints(playerId: playerId, tournamentId: tournamentId, points: 0);
  }

  static PlayerTournamentPoints getByPlayerIdAndTournamentId(String playerId, String tournamentId) {
    return objectbox.store
        .box<PlayerTournamentPoints>()
        .query(PlayerTournamentPoints_.playerId.equals(playerId) & PlayerTournamentPoints_.tournamentId.equals(tournamentId))
        .build()
        .findFirst()!;
  }

  static void deleteAllByTournamentId(String tournamentId) {
    objectbox.store
        .box<PlayerTournamentPoints>()
        .query(PlayerTournamentPoints_.tournamentId.equals(tournamentId))
        .build()
        .remove();
  }

  static void deleteByPlayerId(String playerId) {
    objectbox.store.box<PlayerTournamentPoints>().query(PlayerTournamentPoints_.playerId.equals(playerId)).build().remove();
  }

  static List<PlayerTournamentPoints> getSortedByPointsDesc(String tournamentId) {
    return objectbox.store
        .box<PlayerTournamentPoints>()
        .query(PlayerTournamentPoints_.tournamentId.equals(tournamentId))
        .order(PlayerTournamentPoints_.points, flags: Order.descending)
        .build()
        .find();
  }

  int save() {
    return objectbox.store.box<PlayerTournamentPoints>().put(this);
  }

  void updatePoints(int points) {
    this.points = points;
    objectbox.store.box<PlayerTournamentPoints>().put(this);
  }

  @override
  String toString() {
    return 'PlayerTournamentPoints(oid: $oid, playerId: $playerId, tournamentId: $tournamentId, points: $points)';
  }
}
