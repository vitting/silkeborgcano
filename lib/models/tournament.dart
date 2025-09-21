import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/main.dart';

import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';

@Entity()
class Tournament {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String name;
  final players = ToMany<Player>();
  final rounds = ToMany<MatchRound>();
  int pointPerMatch;
  final playerTournamentPoints = ToMany<PlayerTournamentPoints>();
  int tournamentStart;
  int tournamentEnd;

  Tournament({
    this.oid = 0,
    this.id = '',
    this.name = '',
    this.pointPerMatch = 0,
    int? tournamentStart,
    int? tournamentEnd,
  }) : tournamentStart =
           tournamentStart ?? DateTime.now().microsecondsSinceEpoch,
       tournamentEnd = tournamentEnd ?? DateTime.now().microsecondsSinceEpoch;

  @override
  String toString() {
    return 'Tournament(oid: $oid, id: $id, name: $name, pointPerMatch: $pointPerMatch)';
  }

  int save({String? name, int? pointPerMatch, List<Player>? players}) {
    if (name != null) this.name = name;
    if (pointPerMatch != null) this.pointPerMatch = pointPerMatch;
    if (players != null) {
      this.players.clear();
      this.players.addAll(players);
    }
    return objectbox.store.box<Tournament>().put(this);
  }

  bool delete() {
    return objectbox.store.box<Tournament>().remove(oid);
  }

  void deletePlayer(Player player) {
    players.removeWhere((p) => p.id == player.id);
    objectbox.store.box<Tournament>().put(this);
  }

  void addPlayer(Player player) {
    if (!players.any((p) => p.id == player.id)) {
      players.add(player);
      objectbox.store.box<Tournament>().put(this);
    }
  }

  List<Player> getPlayersSortedByName() {
    final returnList = players
      ..sort((a, b) => a.name.compareTo(b.name))
      ..toList();
    return returnList;
  }
}
