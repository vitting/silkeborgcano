import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/objectbox.g.dart' show Player_;
import 'package:uuid/uuid.dart';

import 'package:silkeborgcano/main.dart';

@Entity()
class Player {
  @Id()
  int oid; // ObjectBox ID
  String id;
  String name;
  int points;
  String sex; // 'm' for male and 'f' for female, 'u' for unknown
  bool isDeleted;

  Player({this.oid = 0, this.id = '', this.name = '', this.points = 0, this.sex = 'u', this.isDeleted = false});

  factory Player.createNewPlayer({String? name, String? sex}) {
    return Player(id: Uuid().v4(), name: name ?? '', points: 0, sex: sex ?? 'u');
  }

  static Stream<List<Player>> getAllActivePlayersStream() {
    return objectbox.store
        .box<Player>()
        .query(Player_.isDeleted.equals(false))
        .order(Player_.name)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Stream<List<Player>> getAllPlayersStream() {
    return objectbox.store.box<Player>().query().order(Player_.name).watch(triggerImmediately: true).map((query) => query.find());
  }

  static Stream<List<Player>> getAllDeletedPlayersStream() {
    return objectbox.store
        .box<Player>()
        .query(Player_.isDeleted.equals(true))
        .order(Player_.name)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
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

  void delete() {
    objectbox.store.box<Player>().remove(oid);
  }

  @override
  String toString() {
    return 'Player(oid: $oid, id: $id, name: $name, points: $points, sex: $sex, isDeleted: $isDeleted)';
  }
}
