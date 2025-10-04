import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/main.dart';

import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/objectbox.g.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Tournament {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String name;
  final playerTournamentPoints = ToMany<PlayerTournamentPoints>();
  final players = ToMany<Player>();
  int pointPerMatch;
  final rounds = ToMany<MatchRound>();
  int? tournamentEnd;
  int? tournamentStart;

  Tournament({this.oid = 0, this.id = '', this.name = '', this.pointPerMatch = 0, this.tournamentStart, this.tournamentEnd});

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
    objectbox.store.box<Tournament>().put(this);

    PlayerTournamentPoints.deleteAllByTournamentId(id);

    for (var player in players) {
      this.players.add(player);

      final ptp = PlayerTournamentPoints.createPlayerTournamentPoints(playerId: player.id, tournamentId: id);
      ptp.save();
      playerTournamentPoints.add(ptp);
    }
    objectbox.store.box<Tournament>().put(this);
  }

  void addNewPlayer(Player player) {
    players.add(player);
    final ptp = PlayerTournamentPoints.createPlayerTournamentPoints(playerId: player.id, tournamentId: id);
    ptp.save();
    playerTournamentPoints.add(ptp);
    objectbox.store.box<Tournament>().put(this);
  }

  void removePlayer(Player player) {
    players.removeWhere((p) => p.id == player.id);
    playerTournamentPoints.removeWhere((ptp) => ptp.playerId == player.id);
    objectbox.store.box<Tournament>().put(this);

    PlayerTournamentPoints.deleteByPlayerId(player.id);
  }

  bool delete() {
    PlayerTournamentPoints.deleteAllByTournamentId(id);
    return objectbox.store.box<Tournament>().remove(oid);
  }

  void deletePlayerWithEmptyName(Player player) {
    if (player.name.isNotEmpty) {
      throw Exception('Player name is not empty');
    }

    players.removeWhere((p) => p.id == player.id);
    playerTournamentPoints.removeWhere((ptp) => ptp.playerId == player.id);
    objectbox.store.box<Tournament>().put(this);

    PlayerTournamentPoints.deleteByPlayerId(player.id);

    player.delete();
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

  List<Player> getPlayersSortedByPoints() {
    final playersWithPoints = PlayerTournamentPoints.getSortedByPointsDesc(id);
    return playersWithPoints.map((ptp) => players.firstWhere((p) => p.id == ptp.playerId)).toList();
  }
}
