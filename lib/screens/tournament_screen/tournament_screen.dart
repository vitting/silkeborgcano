import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/chose_player_dialog.dart';
import 'package:silkeborgcano/screens/tournament_screen/delete_tournament_dialog.dart';
import 'package:silkeborgcano/screens/tournament_screen/section_header.dart';
import 'package:silkeborgcano/screens/tournament_screen/selected_players.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int? tournamentId = GoRouterState.of(context).extra as int?;

    if (tournamentId != null) {
      tournament = objectbox.store.box<Tournament>().get(tournamentId);
      debugPrint('********** didChangeDependencies tournamentId: $tournament');
    } else {
      tournament = Tournament(id: Uuid().v4(), name: '', pointPerMatch: 21);
      tournament!.save();
    }
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
                final result = await DeleteTournamentDialog.show(context);

                if (result == true) {
                  if (tournament != null) {
                    objectbox.store.box<Tournament>().remove(tournament!.oid);
                  }
                  if (mounted) {
                    context.goNamed(HomeScreen.routerPath);
                  }
                }
              },
              icon: Icon(Icons.delete_forever_rounded),
            ),
        ],
      ),
      body: Column(
        children: [
          SectionHeader(title: 'Navn på turnering'),
          EditableListTile(
            initialValue: tournament?.name,
            isEditing: tournament?.name.isEmpty ?? true,
            showDelete: false,
            onChanged: (value) {
              setState(() {
                tournament?.save(name: value);
              });
            },
          ),
          SectionHeader(title: 'Point per kamp'),
          RadioGroup<int>(
            groupValue: tournament?.pointPerMatch,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                tournament?.save(pointPerMatch: value);
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
              const Gap(82),
              Expanded(
                child: SectionHeader(
                  title: 'Spillere (${tournament?.players.length})',
                ),
              ),
              IconButton(
                onPressed: () async {
                  final List<Player>? chosenPlayers =
                      await ChosePlayerDialog.show(
                        context,
                        tournament?.players.toList() ?? [],
                      );

                  if (chosenPlayers != null) {
                    setState(() {
                      tournament?.save(players: chosenPlayers);
                    });
                  }
                },
                color: Colors.blue,
                iconSize: 28,
                icon: Icon(Icons.group_add),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    final newPlayer = Player(
                      id: Uuid().v4(),
                      name: '',
                      points: 0,
                    );
                    tournament?.players.add(newPlayer);
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
            child: SelectedPlayers(
              players: tournament?.getPlayersSortedByName() ?? [],
              onChanged: (player, name) {
                player.save(name: name);
                tournament?.save();
              },
              onTapOutsideWithEmptyValue: (player) {
                setState(() {
                  tournament?.deletePlayer(player);
                });
              },
              onDelete: (player) {
                setState(() {
                  tournament?.deletePlayer(player);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
