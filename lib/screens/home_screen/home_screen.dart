import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_menu_anchor.dart';
import 'package:silkeborgcano/widgets/custom_menu_item_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';
import 'package:silkeborgcano/widgets/screen_scaffold_title.dart';

enum TournamentFilter { all, notStarted, active, ended }

class HomeScreen extends StatefulWidget {
  static const String routerPath = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TournamentFilter _filter = TournamentFilter.all;
  String getTournamentStatusText(Tournament tournament) {
    if (tournament.isTournamentEnded) {
      return 'Afsluttet (${DateFormat('dd-MM-yyyy').format(tournament.tournamentEndUtc!.toLocal())})';
    }

    if (tournament.isTournamentActive) {
      return 'Aktiv (${DateFormat('dd-MM-yyyy').format(tournament.tournamentStartUtc!.toLocal())})';
    }

    return 'Ikke startet';
  }

  Stream<List<Tournament>> get _filteredTournamentStream {
    switch (_filter) {
      case TournamentFilter.all:
        return Tournament.listOfAllTournamentsAsStream;
      case TournamentFilter.notStarted:
        return Tournament.listOfNotStartedTournamentsAsStream;
      case TournamentFilter.active:
        return Tournament.listOfActiveTournamentsAsStream;
      case TournamentFilter.ended:
        return Tournament.listOfEndedTournamentsAsStream;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: ScreenScaffoldTitle('Turneringer'),
      leading: SizedBox.shrink(),

      floatingActionButton: CustomFloatingActionButtonWithBottomSheetMenu(
        menuItems: [
          CustomFloatingActionButtonWithMenuModel(
            text: 'Opret ny turnering',
            icon: Symbols.add,
            onPressed: () {
              context.goNamed(TournamentScreen.routerPath);
            },
          ),
          CustomFloatingActionButtonWithMenuModel(
            text: 'Administrer spillere',
            icon: Symbols.groups,
            onPressed: () {
              AdministratePlayersDialog.show(context);
            },
          ),
        ],
      ),
      actions: [
        CustomMenuAnchor(
          menuChildren: [
            CustomText(data: 'Filter:', size: CustomTextSize.ms),
            const Gap(AppSizes.xs),
            CustomMenuItemButton(
              text: 'Alle',
              onPressed: () {
                setState(() {
                  _filter = TournamentFilter.all;
                });
              },
              popMenuOnPressed: false,
              selectedByCheckmark: _filter == TournamentFilter.all,
            ),
            const Gap(AppSizes.xs),
            CustomMenuItemButton(
              text: 'Ikke startet',
              onPressed: () {
                setState(() {
                  _filter = TournamentFilter.notStarted;
                });
              },
              popMenuOnPressed: false,
              selectedByCheckmark: _filter == TournamentFilter.notStarted,
            ),
            const Gap(AppSizes.xs),
            CustomMenuItemButton(
              text: 'Aktiv',
              onPressed: () {
                setState(() {
                  _filter = TournamentFilter.active;
                });
              },
              popMenuOnPressed: false,
              selectedByCheckmark: _filter == TournamentFilter.active,
            ),
            const Gap(AppSizes.xs),
            CustomMenuItemButton(
              text: 'Afsluttet',
              onPressed: () {
                setState(() {
                  _filter = TournamentFilter.ended;
                });
              },
              popMenuOnPressed: false,
              selectedByCheckmark: _filter == TournamentFilter.ended,
            ),
          ],
          icon: Symbols.filter_list,
        ),
      ],
      body: Column(
        children: [
          Column(children: [
              
            ],
          ),
          StreamBuilder(
            stream: _filteredTournamentStream,
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return CircularProgressIndicator();
              }

              if (asyncSnapshot.hasError) {
                return CustomText(data: 'Error: ${asyncSnapshot.error}');
              }

              final data = asyncSnapshot.data!;

              if (data.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(data: 'Opret din første turnering', textAlign: TextAlign.center),
                        const Gap(8),
                        CustomIconButton(
                          showBackground: true,
                          icon: Symbols.add,
                          onPressed: () {
                            context.goNamed(TournamentScreen.routerPath);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => ListViewSeparator(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final tournament = data[index];
                    final currentMatchRound = tournament.getCurrentMatchRound();
                    final isTournamentActive = tournament.isTournamentActive;
                    final isTournamentEnded = tournament.isTournamentEnded;
                    return CustomListTile(
                      subtitle: CustomText(
                        data: getTournamentStatusText(tournament),
                        size: CustomTextSize.s,
                        textAlign: TextAlign.end,
                      ),
                      trailing: (currentMatchRound?.active ?? false) && currentMatchRound!.roundIndex > 1
                          ? Icon(Icons.play_arrow)
                          : null,
                      child: CustomText(data: tournament.name),
                      onLongPress: () async {
                        final result = await YesNoDialog.show(
                          context,
                          title: 'Slet turnering',
                          yesButtonText: 'Slet',
                          noButtonText: 'Fortryd',
                          body: 'Er du sikker på at du vil slette turneringen "${tournament.name}"? Dette kan ikke fortrydes.',
                        );
                        if (result != null && result) {
                          tournament.delete();
                        }
                      },
                      onTap: () {
                        // Navigate to the appropriate screen based on tournament state
                        // If there's an active match round, go to MatchesScreen
                        // If the tournament is active but no active round, go to MatchRoundScreen
                        if (currentMatchRound != null) {
                          if (currentMatchRound.active) {
                            context.goNamed(MatchesScreen.routerPath, extra: currentMatchRound.id);
                          } else {
                            context.goNamed(MatchRoundScreen.routerPath, extra: tournament.id);
                          }
                        } else {
                          if (isTournamentActive && !isTournamentEnded) {
                            context.goNamed(MatchRoundScreen.routerPath, extra: tournament.id);
                            return;
                          }

                          if (isTournamentEnded) {
                            final params = TournamentSummaryScreenRouteParams(tournamentId: tournament.id);
                            context.goNamed(TournamentSummaryScreen.routerPath, extra: params);
                            return;
                          }

                          context.goNamed(TournamentScreen.routerPath, extra: tournament.id);
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
