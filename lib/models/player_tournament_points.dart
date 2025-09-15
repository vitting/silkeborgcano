import 'package:objectbox/objectbox.dart';

@Entity()
class PlayerTournamentPoints {
  @Id()
  int oid; // ObjectBox ID
  String playerId;
  int points;

  PlayerTournamentPoints({this.oid = 0, this.points = 0, this.playerId = ''});
}
