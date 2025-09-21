import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/chose_player_dialog.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/screens/tournament_screen/match_points_selector.dart';
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
  Tournament? _tournament;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final Tournament? tournament =
          GoRouterState.of(context).extra as Tournament?;

      if (tournament != null) {
        _tournament = tournament;
        debugPrint(
          '********** didChangeDependencies tournamentId: $_tournament',
        );
      } else {
        _tournament = Tournament(id: Uuid().v4(), name: '', pointPerMatch: 21);
        _tournament?.save();
      }
    }
  }

  bool _validateName() {
    return _tournament != null && _tournament!.name.isNotEmpty;
  }

  bool _validateNumberOfPlayers() {
    return _tournament != null && _tournament!.players.length >= 4;
  }

  void _navigateToHome() {
    if (mounted) {
      context.goNamed(HomeScreen.routerPath);
    }
  }

  Future<void> _validateAndReturnToHome() async {
    bool nameValid = _validateName();
    bool numberOfPlayersValid = _validateNumberOfPlayers();

    if (nameValid == false) {
      final deleteTournament = await YesNoDialog.show(
        context,
        title: 'Turneringen skal have et navn. Vil du slette turneringen?',
        noButtonText: 'Fortryd',
        yesButtonText: 'Slet',
      );

      if (deleteTournament != null && deleteTournament == true) {
        _tournament?.delete();
        _navigateToHome();
      }

      return;
    }

    if (mounted && numberOfPlayersValid == false) {
      final deleteTournament = await YesNoDialog.show(
        context,
        title:
            'Turneringen skal have mindst 4 spillere. Vil du slette turneringen?',
        noButtonText: 'Fortryd',
        yesButtonText: 'Slet',
      );

      if (deleteTournament != null && deleteTournament == true) {
        _tournament?.delete();
        _navigateToHome();
      }

      return;
    }

    _navigateToHome();
  }

  @override
  Widget build(BuildContext context1) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await _validateAndReturnToHome();
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async {
              await _validateAndReturnToHome();
            },
          ),
          title: ElevatedButton.icon(
            onPressed: () {
              context.goNamed(MatchRoundScreen.routerPath, extra: _tournament);
            },
            iconAlignment: IconAlignment.end,
            label: Text('Start turnering'),
            icon: Icon(Icons.play_arrow),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Slet turnering',
              onPressed: () async {
                final result = await YesNoDialog.show(
                  context,
                  title: 'Vil du slette turneringen?',
                  noButtonText: 'Fortryd',
                  yesButtonText: 'Slet',
                );

                if (result == true && _tournament != null) {
                  _tournament?.delete();

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
              initialValue: _tournament?.name,
              isEditing: _tournament?.name.isEmpty ?? false,
              showDelete: false,
              onChanged: (value) {
                setState(() {
                  _tournament?.save(name: value.trim());
                });
              },
            ),
            SectionHeader(title: 'Point per kamp'),
            MatchPointsSelector(
              initialPointPerMatch: _tournament?.pointPerMatch,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _tournament?.save(pointPerMatch: value);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Gap(82),
                Expanded(
                  child: SectionHeader(
                    title: 'Spillere (${_tournament?.players.length})',
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final List<Player>? chosenPlayers =
                        await ChosePlayerDialog.show(
                          context,
                          _tournament?.players.toList() ?? [],
                        );

                    if (chosenPlayers != null) {
                      setState(() {
                        _tournament?.save(players: chosenPlayers);
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
                      _tournament?.players.add(newPlayer);
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
                players: _tournament?.getPlayersSortedByName() ?? [],
                onChanged: (player, name) {
                  player.save(name: name.trim());
                  _tournament?.save();
                },
                onTapOutsideWithEmptyValue: (player) {
                  setState(() {
                    _tournament?.deletePlayer(player);
                  });
                },
                onDelete: (player) {
                  setState(() {
                    _tournament?.deletePlayer(player);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
