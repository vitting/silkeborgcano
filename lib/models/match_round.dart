import 'package:objectbox/objectbox.dart' show Entity, Id, ToMany;
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';

@Entity()
class MatchRound {
  String id;
  final matches = ToMany<Match>();

  @Id()
  int oid; // ObjectBox ID

  final playerMatchPoints = ToMany<PlayerMatchPoints>();
  final players = ToMany<Player>();
  int roundIndex;
  String tournamentId;

  MatchRound({this.oid = 0, this.roundIndex = 0, this.tournamentId = '', this.id = ''});

  int save({List<Player>? players}) {
    if (players != null) {
      this.players.clear();
      this.players.addAll(players);
    }
    return objectbox.store.box<MatchRound>().put(this);
  }

  void delete() {
    PlayerMatchPoints.deleteByMatchRoundId(id);
    objectbox.store.box<MatchRound>().remove(oid);
  }

  void setPlayers(List<Player> newPlayers) {
    players.clear();
    playerMatchPoints.clear();
    PlayerMatchPoints.deleteByMatchRoundId(id);

    for (var player in newPlayers) {
      players.add(player);
      final pmp = PlayerMatchPoints(playerId: player.id, points: 0, matchRoundId: id);
      pmp.save();
      playerMatchPoints.add(pmp);
    }
    objectbox.store.box<MatchRound>().put(this);
  }

  List<Player> getPlayersSortedByName() {
    final returnList = players
      ..sort((a, b) => a.name.compareTo(b.name))
      ..toList();
    return returnList;
  }

  List<Player> getPlayersSortedByPoints() {
    final playersWithPoints = PlayerMatchPoints.getSortedByPoints(id);
    return playersWithPoints.map((pmp) => players.firstWhere((p) => p.id == pmp.playerId)).toList();
  }
}
