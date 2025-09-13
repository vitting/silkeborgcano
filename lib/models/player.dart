import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/main.dart';
import 'package:uuid/uuid.dart';

@Entity()
class Player {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String name;
  int points;
  String sex; // 'm' for male and 'f' for female, 'u' for unknown
  bool isDeleted;

  Player({
    this.oid = 0,
    this.id = '',
    this.name = '',
    this.points = 0,
    this.sex = 'u',
    this.isDeleted = false,
  });

  factory Player.newPlayer({String? name, String? sex}) {
    return Player(
      id: Uuid().v4(),
      name: name ?? '',
      points: 0,
      sex: sex ?? 'u',
    );
  }

  void markAsDeleted() {
    isDeleted = true;
    objectbox.store.box<Player>().put(this);
  }

  int save({String? name, int? points, String? sex, bool? isDeleted}) {
    if (name != null) this.name = name;
    if (points != null) this.points = points;
    if (sex != null) this.sex = sex;
    if (isDeleted != null) this.isDeleted = isDeleted;
    return objectbox.store.box<Player>().put(this);
  }
}
