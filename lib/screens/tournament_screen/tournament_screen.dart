import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/chose_player_dialog.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/screens/tournament_screen/match_points_selector.dart';
import 'package:silkeborgcano/screens/tournament_screen/section_header.dart';
import 'package:silkeborgcano/screens/tournament_screen/selected_players.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/editable_list_tile.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';
import 'package:silkeborgcano/widgets/screen_scaffold_title.dart';
import 'package:vibration/vibration.dart';

class TournamentScreen extends StatefulWidget {
  static const String routerPath = "/tournament";
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> with StorageMixin {
  Tournament? _tournament;
  bool isValid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final Tournament? tournament = getTournamentById(context);

      if (tournament != null) {
        _tournament = tournament;
        isValid = isTournamentValid;
      } else {
        _tournament = Tournament.newTournament();
        _tournament!.save();
      }
    }
  }

  bool _isNameValid() {
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

  bool get isTournamentValid {
    final isNameValid = _isNameValid();
    final hasEnoughPlayers = _validateNumberOfPlayers();

    return isNameValid && hasEnoughPlayers;
  }

  Future<void> _validateAndReturnToHome() async {
    if (_isNameValid() == false) {
      _tournament?.delete();
      _navigateToHome();

      return;
    }

    if (mounted && _validateNumberOfPlayers() == false) {
      final deleteTournament = await YesNoDialog.show(
        context,
        title: 'Turneringen skal have mindst 4 spillere. Vil du slette turneringen?',
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
      child: ScreenScaffold(
        onHomeTap: () async {
          await _validateAndReturnToHome();
        },
        title: ScreenScaffoldTitle('Turnering'),
        floatingActionButton: isValid
            ? CustomFloatingActionButton(
                tooltip: 'Start turnering',
                onPressed: () {
                  context.goNamed(MatchRoundScreen.routerPath, extra: _tournament!.id);
                },
                icon: Symbols.play_arrow,
              )
            : null,
        actions: [
          CustomIconButton(
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
            icon: Symbols.delete_forever_rounded,
          ),
        ],
        body: ListView(
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
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _tournament?.name.isNotEmpty ?? false ? 1 : 0,
              child: Column(
                children: [
                  SectionHeader(title: 'Point per kamp'),
                  const Gap(8),
                  MatchPointsSelector(
                    initialPointPerMatch: _tournament?.pointPerMatch,
                    onChanged: (value) async {
                      if (value == null) return;
                      if (await Vibration.hasVibrator()) {
                        Vibration.vibrate(duration: 100);
                      }

                      setState(() {
                        _tournament?.save(pointPerMatch: value);
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        tooltip: 'Tilføj ny spiller',
                        onPressed: () {
                          setState(() {
                            final newPlayer = Player.createNewPlayer();
                            _tournament?.addNewPlayer(newPlayer);
                          });
                        },
                        icon: Symbols.add,
                      ),
                      const Gap(AppSizes.s),
                      SectionHeader(title: 'Spillere'),
                      const Gap(AppSizes.xs),
                      CircleAvatar(
                        radius: AppSizes.s,
                        backgroundColor: AppColors.textAndIcon,
                        child: Text(
                          _tournament?.players.length.toString() ?? '0',
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: AppSizes.s),
                        ),
                      ),
                      const Gap(AppSizes.s),
                      CustomIconButton(
                        tooltip: 'Vælg eksisterende spillere',
                        onPressed: () async {
                          final List<Player>? chosenPlayers = await ChosePlayerDialog.show(
                            context,
                            _tournament?.players.toList() ?? [],
                          );

                          if (chosenPlayers != null) {
                            setState(() {
                              _tournament?.setPlayers(chosenPlayers);
                            });
                          }
                        },
                        icon: Symbols.group_add,
                      ),
                    ],
                  ),
                  SelectedPlayers(
                    players: _tournament?.getPlayersSortedByName() ?? [],
                    onChanged: (player, name) {
                      player.save(name: name.trim());
                      _tournament?.save();
                    },
                    onTapOutsideWithEmptyValue: (player) {
                      setState(() {
                        _tournament?.deletePlayerWithEmptyName(player);
                      });
                    },
                    onDelete: (player) {
                      setState(() {
                        if (player.name.isNotEmpty) {
                          _tournament?.removePlayer(player);
                        } else {
                          _tournament?.deletePlayerWithEmptyName(player);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const Gap(AppSizes.xs),
          ],
        ),
      ),
    );
  }
}
