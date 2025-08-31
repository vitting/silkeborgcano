import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/cubits/tournament_screen_cubit/tournament_screen_cubit.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen.dart';
import 'package:silkeborgcano/widgets/editable_list_tile.dart';
import 'package:uuid/uuid.dart';

class TournamentScreen extends StatefulWidget {
  static const String routerPath = "/tournament";
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  Tournament _getTournament(BuildContext context) {
    final Tournament? tournament =
        GoRouterState.of(context).extra as Tournament?;
    if (tournament == null) {
      return Tournament(
        id: Uuid().v4(),
        name: '',
        players: [],
        pointPerMatch: 21,
        rounds: [],
      );
    }

    return tournament;
  }

  bool _isNewTournament(BuildContext context) {
    final Tournament? tournament =
        GoRouterState.of(context).extra as Tournament?;
    return tournament == null;
  }

  @override
  Widget build(BuildContext context1) {
    return BlocProvider(
      create: (context) => TournamentScreenCubit(_getTournament(context1)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.goNamed(HomeScreen.routerPath);
                },
              ),
              title: ElevatedButton.icon(
                onPressed: () {},
                iconAlignment: IconAlignment.end,
                label: Text('Start turnering'),
                icon: Icon(Icons.play_arrow),
              ),
              centerTitle: true,
              actions: [
                if (_isNewTournament(context) == false)
                  IconButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Vil du slette turneringen?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Fortryd'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete action
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Slet'),
                              ),
                            ],
                          );
                        },
                      );

                      debugPrint('****************Dialog result: $result');
                    },
                    icon: Icon(Icons.delete),
                  ),
              ],
            ),
            body: BlocBuilder<TournamentScreenCubit, Tournament>(
              builder: (context, state) {
                return Column(
                  // physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                      'Turnerings navn',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    EditableListTile(
                      initialValue: state.name,
                      isEditing: state.name.isEmpty,
                      showDelete: false,
                      onChanged: (value) {
                        context
                            .read<TournamentScreenCubit>()
                            .updateTournamentName(value);
                      },
                    ),
                    Text(
                      'Point per kamp',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Gap(72),
                        Expanded(
                          child: Text(
                            'Spillere (${state.players.length})',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<TournamentScreenCubit>().addPlayer(
                              Player(id: Uuid().v4(), name: '', points: 0),
                            );
                          },
                          icon: Icon(Icons.add),
                          color: Colors.blue,
                          iconSize: 28,
                        ),
                        const Gap(24),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.players.length,
                        itemBuilder: (context, index) {
                          final item = state.players.elementAt(index);
                          return EditableListTile(
                            initialValue: item.name,
                            isEditing: item.name.isEmpty,
                            onTapOutside: (value) {
                              if (value.isEmpty) {
                                context
                                    .read<TournamentScreenCubit>()
                                    .removePlayer(item);
                              }
                            },
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
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
