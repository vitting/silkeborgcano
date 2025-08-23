class Player {
  final String id;
  final String name;
  final int points;

  Player({required this.id, required this.name, required this.points});

  Player copyWith({String? name, int? points}) {
    return Player(
      id: id,
      name: name ?? this.name,
      points: points ?? this.points,
    );
  }
}
