import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silkeborgcano/cubits/tournament_screen_cubit/tournament_screen_cubit.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/widgets/editable_list_tile.dart';
import 'package:uuid/uuid.dart';

class TournamentScreen extends StatelessWidget {
  static const String routerPath = "/tournament";
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TournamentScreenCubit(
        Tournament(
          id: Uuid().v4(),
          name: '',
          players: [],
          pointPerMatch: 21,
          rounds: [],
        ),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: BlocBuilder<TournamentScreenCubit, Tournament>(
                builder: (context, state) {
                  return ListView(
                    children: [
                      Text('Turnerings navn'),
                      EditableListTile(
                        initialValue: '',
                        isEditing: state.name.isEmpty,
                        showDelete: false,
                        onChanged: (value) {
                          context
                              .read<TournamentScreenCubit>()
                              .updateTournamentName(value);
                        },
                      ),
                      Text('Point per kamp'),
                      RadioGroup<int>(
                        groupValue: state.pointPerMatch,
                        onChanged: (value) {
                          if (value == null) return;
                          context
                              .read<TournamentScreenCubit>()
                              .updatePointPerMatch(value);
                        },
                        child: Row(
                          children: [
                            Flexible(
                              child: RadioListTile(
                                value: 11,
                                title: Text('11'),
                                dense: true,
                              ),
                            ),
                            Flexible(
                              child: RadioListTile(
                                value: 15,
                                title: Text('15'),
                                dense: true,
                              ),
                            ),
                            Flexible(
                              child: RadioListTile(
                                value: 21,
                                title: Text('21'),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Spillere (${state.players.length})'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.players.length,
                        itemBuilder: (context, index) {
                          final item = state.players.elementAt(index);
                          return EditableListTile(
                            initialValue: item.name,
                            isEditing: item.name.isEmpty,
                            onChanged: (value) {
                              context
                                  .read<TournamentScreenCubit>()
                                  .updatePlayer(item, value);
                            },
                            onDelete: () {
                              context
                                  .read<TournamentScreenCubit>()
                                  .removePlayer(item);
                            },
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          context.read<TournamentScreenCubit>().addPlayer(
                            Player(id: Uuid().v4(), name: '', points: 0),
                          );
                        },
                        child: Text('Tilføj spiller'),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
