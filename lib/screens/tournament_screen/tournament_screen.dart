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
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
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
  bool _isValid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tournament == null) {
      final Tournament? tournament = getTournamentById(context);

      if (tournament != null) {
        _tournament = tournament;
        _isValid = isTournamentValid;
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

  void _checkIfTournamentIsValidOnChanges() {
    final valid = isTournamentValid;
    if (valid != _isValid) {
      setState(() {
        _isValid = valid;
      });
    }
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
        title: 'Slet turnering',
        body: 'Turneringen skal have mindst 4 spillere. Vil du slette turneringen?',
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
        showBackgroundImage: false,
        onHomeTap: () async {
          await _validateAndReturnToHome();
        },
        title: ScreenScaffoldTitle('Turnering'),
        floatingActionButton: _isValid
            ? CustomFloatingActionButtonWithBottomSheetMenu(
                menuItems: [
                  CustomFloatingActionButtonWithMenuModel(
                    text: 'Start turnering',
                    icon: Symbols.sports_volleyball,
                    onPressed: () {
                      if (_tournament != null) {
                        context.goNamed(MatchRoundScreen.routerPath, extra: _tournament!.id);
                      }
                    },
                  ),
                  CustomFloatingActionButtonWithMenuModel(
                    text: 'Slet turnering',
                    icon: Symbols.delete_forever_rounded,
                    onPressed: () async {
                      final result = await YesNoDialog.show(
                        context,
                        title: 'Slet turnering',
                        body: 'Vil du slette turneringen?',
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
                  ),
                ],
              )
            : null,

        body: ListView(
          children: [
            SectionHeader(title: 'Navn på turnering'),
            const Gap(AppSizes.xs),
            EditableListTile(
              initialValue: _tournament?.name,
              isEditing: _tournament?.name.isEmpty ?? false,
              showDelete: false,
              onChanged: (value) {
                setState(() {
                  _tournament?.save(name: value.trim());
                  _isValid = isTournamentValid;
                });
              },
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _tournament?.name.isNotEmpty ?? false ? 1 : 0,
              child: Column(
                children: [
                  const Gap(AppSizes.xs),
                  SectionHeader(title: 'Point per kamp'),
                  const Gap(8),
                  CustomListTile(
                    child: MatchPointsSelector(
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        size: CustomIconSize.m,
                        tooltip: 'Tilføj ny spiller',
                        onPressed: () {
                          setState(() {
                            final newPlayer = Player.createNewPlayer();
                            _tournament?.addNewPlayer(newPlayer);
                            _isValid = isTournamentValid;
                          });
                        },
                        icon: Symbols.person_add,
                      ),
                      const Gap(AppSizes.s),
                      SectionHeader(title: 'Spillere (${_tournament?.players.length ?? 0})'),
                      const Gap(AppSizes.xs),
                      CustomIconButton(
                        size: CustomIconSize.m,
                        tooltip: 'Vælg eksisterende spillere',
                        onPressed: () async {
                          final List<Player>? chosenPlayers = await ChosePlayerDialog.show(
                            context,
                            _tournament?.players.toList() ?? [],
                          );

                          if (chosenPlayers != null) {
                            setState(() {
                              _tournament?.setPlayers(chosenPlayers);
                              _isValid = isTournamentValid;
                            });
                          }
                        },
                        icon: Symbols.groups,
                      ),
                    ],
                  ),
                  SelectedPlayers(
                    players: _tournament?.getPlayersSortedByName() ?? [],
                    onChanged: (player, name) {
                      player.save(name: name.trim());
                      _tournament?.save();
                      _checkIfTournamentIsValidOnChanges();
                    },
                    onTapOutsideWithEmptyValue: (player) {
                      setState(() {
                        _tournament?.deletePlayerWithEmptyName(player);
                        _isValid = isTournamentValid;
                      });
                    },
                    onDelete: (player) {
                      setState(() {
                        if (player.name.isNotEmpty) {
                          _tournament?.removePlayer(player);
                          _isValid = isTournamentValid;
                        } else {
                          _tournament?.deletePlayerWithEmptyName(player);
                          _isValid = isTournamentValid;
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
