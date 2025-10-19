import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/models/app_settings.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen_filter_menu.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen_list_tile.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';
import 'package:silkeborgcano/widgets/screen_scaffold_title.dart';

class HomeScreen extends StatefulWidget {
  static const String routerPath = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TournamentFilter _filter;
  late AppSettings _appSettings;
  bool _noTournaments = true;

  @override
  void initState() {
    super.initState();

    _appSettings = AppSettings.getSettings();
    _filter = TournamentFilter.fromString(_appSettings.filter);

    Tournament.listOfAllTournamentsAsStream.listen((onData) {
      setState(() {
        _noTournaments = onData.isEmpty;
      });
    });
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
      body: Column(
        children: [
          if (!_noTournaments)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HomeScreenFilterMenu(
                  selectedFilter: _filter,
                  onFilterSelected: (selectedFilter) {
                    setState(() {
                      _filter = selectedFilter;
                      _appSettings.updateFilter(_filter.value);
                    });
                  },
                ),
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

              if (_noTournaments) {
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
                    return HomeScreenListTile(
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
                      tournament: tournament,
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
