import 'package:objectbox/objectbox.dart' show Entity, Id, ToMany;
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_calculation.dart';
import 'package:uuid/uuid.dart';

@Entity()
class MatchRound {
  @Id()
  int oid; // ObjectBox ID
  String id;
  int roundIndex;
  String tournamentId;
  bool active;
  final matches = ToMany<Match>();
  final players = ToMany<Player>();
  final sittingOver = ToMany<Player>();
  final playerMatchPoints = ToMany<PlayerMatchPoints>();

  MatchRound({this.oid = 0, this.roundIndex = 0, this.tournamentId = '', this.id = '', this.active = false});

  factory MatchRound.createMatchRound({required String tournamentId, required int roundIndex, required List<Player> players}) {
    final m = MatchRound(id: Uuid().v4(), tournamentId: tournamentId, roundIndex: roundIndex, active: false);
    m.save();
    m.setPlayers(players);
    return m;
  }

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

  void setSittingOverPlayers(List<Player> players) {
    sittingOver.clear();
    sittingOver.addAll(players);
    objectbox.store.box<MatchRound>().put(this);
  }

  void setMatches(List<CourtMatch> matches) {
    this.matches.clear();
    objectbox.store.box<MatchRound>().put(this);
    Match.deleteAllByMatchRoundId(id);

    for (var match in matches) {
      final Match m = Match(id: Uuid().v4(), matchRoundId: id, courtNumber: match.courtNumber, tournamentId: tournamentId);
      m.addTeam1Players(match.team1.players);
      m.addTeam2Players(match.team2.players);
      this.matches.add(m);
    }

    objectbox.store.box<MatchRound>().put(this);
  }

  void setActive(bool isActive) {
    active = isActive;
    objectbox.store.box<MatchRound>().put(this);
  }
}
