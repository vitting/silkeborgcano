import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/main.dart';

import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/objectbox.g.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Tournament {
  String id;
  String name;
  @Id()
  int oid; // ObjectBox ID

  final playerTournamentPoints = ToMany<PlayerTournamentPoints>();
  final players = ToMany<Player>();
  int pointPerMatch;
  final rounds = ToMany<MatchRound>();
  int tournamentEnd;
  int tournamentStart;

  Tournament({this.oid = 0, this.id = '', this.name = '', this.pointPerMatch = 0, int? tournamentStart, int? tournamentEnd})
    : tournamentStart = tournamentStart ?? DateTime.now().millisecondsSinceEpoch,
      tournamentEnd = tournamentEnd ?? DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() {
    return 'Tournament(oid: $oid, id: $id, name: $name, pointPerMatch: $pointPerMatch)';
  }

  factory Tournament.newTournament({String name = '', int pointPerMatch = 21}) {
    return Tournament(id: Uuid().v4(), name: name, pointPerMatch: pointPerMatch);
  }

  static Stream<List<Tournament>> get listOfAllTournamentsAsStream {
    return objectbox.store.box<Tournament>().query().watch(triggerImmediately: true).map((query) => query.find());
  }

  int save({String? name, int? pointPerMatch}) {
    if (name != null) this.name = name;
    if (pointPerMatch != null) this.pointPerMatch = pointPerMatch;
    return objectbox.store.box<Tournament>().put(this);
  }

  void setPlayers(List<Player> players) {
    this.players.clear();
    playerTournamentPoints.clear();
    PlayerTournamentPoints.deleteAllByTournamentId(id);

    for (var player in players) {
      this.players.add(player);

      final ptp = PlayerTournamentPoints(playerId: player.id, points: 0, tournamentId: id);
      ptp.save();
      playerTournamentPoints.add(ptp);
    }
    objectbox.store.box<Tournament>().put(this);
  }

  bool delete() {
    PlayerTournamentPoints.deleteAllByTournamentId(id);
    return objectbox.store.box<Tournament>().remove(oid);
  }

  void deletePlayer(Player player) {
    players.removeWhere((p) => p.id == player.id);
    PlayerTournamentPoints.deleteByPlayerId(player.id);
    objectbox.store.box<Tournament>().put(this);
  }

  List<Player> getPlayersSortedByName() {
    final returnList = players
      ..sort((a, b) => a.name.compareTo(b.name))
      ..toList();
    return returnList;
  }

  void addMatchRound(MatchRound matchRound) {
    if (!rounds.any((r) => r.id == matchRound.id)) {
      rounds.add(matchRound);
      objectbox.store.box<Tournament>().put(this);
    }
  }

  void updateMatchRound(MatchRound matchRound) {
    final index = rounds.indexWhere((r) => r.id == matchRound.id);
    if (index != -1) {
      rounds[index] = matchRound;
      objectbox.store.box<Tournament>().put(this);
    }
  }

  MatchRound? getActiveMatchRound() {
    try {
      return rounds.firstWhere((r) => r.active);
    } catch (e) {
      return null;
    }
  }

  int getLastRoundIndex() {
    return rounds.length;
  }
}
