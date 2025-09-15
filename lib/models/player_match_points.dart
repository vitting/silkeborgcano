import 'package:objectbox/objectbox.dart';

@Entity()
class PlayerMatchPoints {
  @Id()
  int oid; // ObjectBox ID
  String playerId;
  int points;
  bool sittingOver;

  PlayerMatchPoints({
    this.oid = 0,
    this.points = 0,
    this.playerId = '',
    this.sittingOver = false,
  });
}
