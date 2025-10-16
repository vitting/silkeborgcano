import 'package:objectbox/objectbox.dart' show Entity, Id, ToMany;
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/player_match_points.dart';
import 'package:silkeborgcano/models/player_tournament_points.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/objectbox.g.dart' hide Entity, Id;
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
  int? roundEnd;
  int? roundStart;

  MatchRound({
    this.oid = 0,
    this.roundIndex = 0,
    this.tournamentId = '',
    this.id = '',
    this.active = false,
    this.roundStart,
    this.roundEnd,
  });

  factory MatchRound.createMatchRound({required String tournamentId, required int roundIndex, required List<Player> players}) {
    final m = MatchRound(id: Uuid().v4(), tournamentId: tournamentId, roundIndex: roundIndex, active: false);
    m.save();
    m.setPlayers(players);
    return m;
  }

  static void deleteAllByTournamentId(String tournamentId) {
    PlayerMatchPoints.deleteAllByMatchRoundId(tournamentId);
    Match.deleteAllByMatchRoundId(tournamentId);
    objectbox.store.box<MatchRound>().query(MatchRound_.tournamentId.equals(tournamentId)).build().remove();
  }

  static MatchRound? getById(String id) {
    return objectbox.store.box<MatchRound>().query(MatchRound_.id.equals(id)).build().findFirst();
  }

  DateTime? get roundStartUtc {
    if (roundStart != null) {
      return DateTime.fromMillisecondsSinceEpoch(roundStart!);
    }

    return null;
  }

  DateTime? get roundEndUtc {
    if (roundEnd != null) {
      return DateTime.fromMillisecondsSinceEpoch(roundEnd!);
    }

    return null;
  }

  Duration get roundTotalTimeUtc {
    if (roundStart != null && roundEnd != null) {
      return roundEndUtc!.difference(roundStartUtc!);
    }

    return Duration.zero;
  }

  int save() {
    return objectbox.store.box<MatchRound>().put(this);
  }

  void delete() {
    PlayerMatchPoints.deleteAllByMatchRoundId(id);
    objectbox.store.box<MatchRound>().remove(oid);
  }

  void setPlayers(List<Player> newPlayers) {
    players.clear();
    playerMatchPoints.clear();
    PlayerMatchPoints.deleteAllByMatchRoundId(id);

    for (var player in newPlayers) {
      players.add(player);
      final pmp = PlayerMatchPoints.createPlayerMatchPoints(playerId: player.id, matchRoundId: id);
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

  Tournament getTournament() {
    return objectbox.store.box<Tournament>().query(Tournament_.id.equals(tournamentId)).build().findFirst()!;
  }

  void startRound() {
    active = true;
    roundStart = DateTime.now().millisecondsSinceEpoch;
    objectbox.store.box<MatchRound>().put(this);
  }

  void _updatePlayerMatchPoints(int points, List<Player> players) {
    for (var player in players) {
      final ptp = PlayerTournamentPoints.getByPlayerIdAndTournamentId(player.id, tournamentId);
      ptp.updatePoints(ptp.points + points);

      final pmp = PlayerMatchPoints.getByPlayerIdAndMatchRoundId(player.id, id);
      pmp.updatePoints(points);
    }
  }

  void endRound() {
    active = false;
    roundEnd = DateTime.now().millisecondsSinceEpoch;
    getTournament().updateCurrentRoundId('');

    for (var match in matches) {
      final team1Points = match.team1Score;
      final team2Points = match.team2Score;

      _updatePlayerMatchPoints(team1Points, match.team1);
      _updatePlayerMatchPoints(team2Points, match.team2);
    }

    if (sittingOver.isNotEmpty) {
      final sittingOverPoints = Tournament.getPointsPerMatchForPlayersSittingOver(tournamentId);
      _updatePlayerMatchPoints(sittingOverPoints, sittingOver);
    }

    objectbox.store.box<MatchRound>().put(this);
  }

  Set<String> getPlayerIdsSittingOverAsSet() {
    final Set<String> playerIds = {};
    for (var player in sittingOver) {
      playerIds.add(player.id);
    }
    return playerIds;
  }
}
