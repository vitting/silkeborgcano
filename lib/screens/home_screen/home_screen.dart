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
import 'package:silkeborgcano/screens/settings_screen/settings_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_menu_anchor.dart';
import 'package:silkeborgcano/widgets/custom_menu_item_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

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
      if (mounted) {
        setState(() {
          _noTournaments = onData.isEmpty;
        });
      }
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
      title: CustomTextTitle('Turneringer'),
      leading: SizedBox.shrink(),
      actions: [
        CustomMenuAnchor(
          icon: Symbols.menu,
          menuChildren: [
            CustomMenuItemButton(
              icon: Symbols.person,
              popMenuOnPressed: false,
              text: 'Administrer spillere',
              onPressed: () async {
                await AdministratePlayersDialog.show(context);
              },
            ),
            const Gap(AppSizes.xs),
            CustomMenuItemButton(
              icon: Symbols.settings,
              popMenuOnPressed: false,
              text: 'Indstillinger',
              onPressed: () async {
                context.goNamed(SettingsScreen.routerPath);
              },
            ),
          ],
        ),
      ],
      floatingActionButton: CustomFloatingActionButton(
        icon: Symbols.add,
        tooltip: 'Opret ny turnering',
        onPressed: () {
          context.goNamed(TournamentScreen.routerPath);
        },
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
                return CustomText('Error: ${asyncSnapshot.error}');
              }

              final data = asyncSnapshot.data!;

              if (_noTournaments) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText('Opret din første turnering', textAlign: TextAlign.center),
                        const Gap(AppSizes.xs),
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
