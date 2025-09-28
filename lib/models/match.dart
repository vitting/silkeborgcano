import 'package:objectbox/objectbox.dart' show Entity, Id, ToMany;
import 'package:silkeborgcano/main.dart';

import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/objectbox.g.dart' hide Entity, Id;

@Entity()
class Match {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String matchRoundId;
  String tournamentId;
  int courtNumber;
  final team1 = ToMany<Player>();
  final team2 = ToMany<Player>();
  int team1Score;
  int team2Score;

  Match({
    this.oid = 0,
    this.id = '',
    this.team1Score = 0,
    this.team2Score = 0,
    this.matchRoundId = '',
    this.courtNumber = 0,
    this.tournamentId = '',
  });

  static void deleteAllByMatchRoundId(String matchRoundId) {
    objectbox.store.box<Match>().query(Match_.matchRoundId.equals(matchRoundId)).build().remove();
  }

  int save() {
    return objectbox.store.box<Match>().put(this);
  }

  void addTeam1Players(List<Player> players) {
    team1.clear();
    team1.addAll(players);
    objectbox.store.box<Match>().put(this);
  }

  void addTeam2Players(List<Player> players) {
    team2.clear();
    team2.addAll(players);
    objectbox.store.box<Match>().put(this);
  }

  void addScore(int team1Score, int team2Score) {
    this.team1Score = team1Score;
    this.team2Score = team2Score;
    objectbox.store.box<Match>().put(this);
  }

  void addTeam1Score(int score) {
    team1Score = score;
    objectbox.store.box<Match>().put(this);
  }

  void addTeam2Score(int score) {
    team2Score = score;
    objectbox.store.box<Match>().put(this);
  }

  void delete() {
    objectbox.store.box<Match>().remove(oid);
  }

  @override
  String toString() {
    return 'Match(oid: $oid, id: $id, matchRoundId: $matchRoundId, team1Score: $team1Score, team2Score: $team2Score)';
  }
}
