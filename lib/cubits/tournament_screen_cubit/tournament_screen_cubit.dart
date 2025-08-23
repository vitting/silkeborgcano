import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';

class TournamentScreenCubit extends Cubit<Tournament> {
  final Tournament tournament;
  TournamentScreenCubit(this.tournament) : super(tournament);

  void addPlayer(Player player) {
    tournament.players.add(player);

    emit(state.copyWith(players: tournament.players));
  }

  void updatePlayer(Player player, String updatedName) {
    final index = tournament.players.indexWhere(
      (element) => element.id == player.id,
    );
    tournament.players.removeAt(index);
    tournament.players.insert(index, player.copyWith(name: updatedName));

    emit(state.copyWith(players: [...tournament.players]));
  }

  void removePlayer(Player player) {
    tournament.players.removeWhere((element) => element.id == player.id);

    emit(state.copyWith(players: [...tournament.players]));
  }

  void updateTournamentName(String name) {
    emit(state.copyWith(name: name));
  }

  void updatePointPerMatch(int pointPerMatch) {
    emit(state.copyWith(pointPerMatch: pointPerMatch));
  }
}
