import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_bottom_sheet_menu.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button_with_menu_model.dart';
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
                    final currentMatchRound = tournament.getCurrentMatchRound();
                    return CustomListTile(
                      trailing: (currentMatchRound?.active ?? false) && currentMatchRound!.roundIndex > 1
                          ? Icon(Icons.play_arrow)
                          : null,
                      child: CustomText(data: tournament.name),
                      onTap: () {
                        if (currentMatchRound != null) {
                          if (currentMatchRound.active) {
                            context.goNamed(MatchesScreen.routerPath, extra: currentMatchRound.id);
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
