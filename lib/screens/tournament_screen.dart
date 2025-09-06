import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/cubits/tournament_screen_cubit/tournament_screen_cubit.dart';
import 'package:silkeborgcano/main.dart';
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
  Tournament? tournament;
  @override
  void initState() {
    super.initState();

    // if (tournamentId != null) {
    //   tournament = objectbox.store.box<Tournament>().get(tournamentId);
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (tournament != null) return;
    // React to changes in dependencies
    final int? tournamentId = GoRouterState.of(context).extra as int?;

    if (tournamentId != null) {
      tournament = objectbox.store.box<Tournament>().get(tournamentId);
    } else {
      tournament = Tournament(id: Uuid().v4(), name: '', pointPerMatch: 21);

      _saveObjectBox(tournament!);
    }

    debugPrint('********** didUpdateWidget tournamentId: $tournamentId');
  }

  void _saveObjectBox(Tournament tournament) {
    objectbox.store.box<Tournament>().put(tournament);
  }

  void _saveObjectBoxPlayer(Player player) {
    objectbox.store.box<Player>().put(player);
  }

  @override
  Widget build(BuildContext context1) {
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
          if (tournament != null)
            IconButton(
              tooltip: 'Slet turnering',
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
              icon: Icon(Icons.delete_forever_rounded),
            ),
        ],
      ),
      body: Column(
        // physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            'Navn på turnering',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          EditableListTile(
            initialValue: tournament?.name,
            isEditing: tournament?.name.isEmpty ?? true,
            showDelete: false,
            onChanged: (value) {
              setState(() {
                tournament?.name = value;

                _saveObjectBox(tournament!);
              });
            },
          ),
          Text(
            'Point per kamp',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          RadioGroup<int>(
            groupValue: tournament?.pointPerMatch,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                tournament?.pointPerMatch = value;
                _saveObjectBox(tournament!);
              });
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
                  'Spillere (${tournament?.players.length})',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      // objectbox.store.box<Player>().removeAll();
                      final players = objectbox.store.box<Player>().getAll();
                      return Dialog.fullscreen(
                        child: Scaffold(
                          appBar: AppBar(title: Text('Tilføj spiller')),
                          body: ListView.builder(
                            itemCount: players.length,
                            itemBuilder: (context, index) {
                              final item = players[index];
                              return ListTile(
                                title: Text(item.name),
                                onTap: () {
                                  // Check if player already exists in tournament
                                  if (tournament?.players.any(
                                        (element) => element.id == item.id,
                                      ) ??
                                      false) {
                                    // Show snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Spilleren findes allerede i turneringen',
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                    return;
                                  }

                                  // If not exists, add player to tournament

                                  setState(() {
                                    tournament?.players.add(item);
                                    _saveObjectBox(tournament!);
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.favorite),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    final newPlayer = Player(
                      id: Uuid().v4(),
                      name: '',
                      points: 0,
                    );
                    // _saveObjectBoxPlayer(newPlayer);
                    tournament?.players.add(newPlayer);
                    // _saveObjectBox(tournament!);
                  });
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
              itemCount: tournament?.players.length,
              itemBuilder: (context, index) {
                final item = tournament?.players.elementAt(index);
                return EditableListTile(
                  initialValue: item?.name,
                  isEditing: item?.name.isEmpty ?? true,
                  onTapOutside: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        tournament?.players.removeAt(index);
                        _saveObjectBox(tournament!);
                      });
                    }
                  },
                  onChanged: (value) {
                    item!.name = value;
                    _saveObjectBoxPlayer(item);
                  },
                  onDelete: () {
                    setState(() {
                      tournament?.players.removeAt(index);
                      _saveObjectBox(tournament!);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
