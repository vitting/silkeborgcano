import 'package:objectbox/objectbox.dart';

@Entity()
class Player {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String name;
  int points;
  String sex; // 'm' for male and 'f' for female, 'u' for unknown

  Player({
    this.oid = 0,
    this.id = '',
    this.name = '',
    this.points = 0,
    this.sex = 'u',
  });
}
