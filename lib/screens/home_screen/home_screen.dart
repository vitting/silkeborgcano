import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';
import 'package:silkeborgcano/widgets/screen_scaffold_title.dart';

class HomeScreen extends StatelessWidget {
  static const String routerPath = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: ScreenScaffoldTitle('Forside'),
      leading: SizedBox.shrink(),
      actions: [
        IconButton(
          tooltip: 'Administrer spillere',
          icon: CustomIcon(Symbols.groups),
          onPressed: () {
            AdministratePlayersDialog.show(context);
          },
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
          // if (kDebugMode)
          //   ElevatedButton(
          //     onPressed: () {
          //       objectbox.store.box<Tournament>().removeAll();
          //       objectbox.store.box<Player>().removeAll();
          //     },
          //     child: Text('Delete all data'),
          //   ),
          StreamBuilder(
            stream: Tournament.listOfAllTournamentsAsStream,
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return CircularProgressIndicator();
              }

              if (asyncSnapshot.hasError) {
                return CustomText(data: 'Error: ${asyncSnapshot.error}');
              }

              final data = asyncSnapshot.data!;
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => ListViewSeparator(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final tournament = data[index];
                    return CustomListTile(
                      child: CustomText(data: tournament.name),
                      onTap: () {
                        final matchRound = tournament.getCurrentMatchRound();

                        debugPrint('ACtive mach round: $matchRound');

                        if (matchRound != null) {
                          if (matchRound.active) {
                            context.goNamed(MatchesScreen.routerPath, extra: matchRound.id);
                          } else {
                            context.goNamed(MatchRoundScreen.routerPath, extra: tournament.id);
                          }
                        } else {
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
