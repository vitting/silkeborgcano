import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/player_dialog.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/screens/home_screen/administrate_players_dialog_filter_menu.dart';
import 'package:silkeborgcano/screens/home_screen/player_edit_list.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class AdministratePlayersDialog extends StatefulWidget {
  const AdministratePlayersDialog({super.key});

  static Future<List<Player>?> show(BuildContext context) {
    return showDialog<List<Player>?>(context: context, builder: (context) => AdministratePlayersDialog());
  }

  @override
  State<AdministratePlayersDialog> createState() => _AdministratePlayersDialogState();
}

class _AdministratePlayersDialogState extends State<AdministratePlayersDialog> {
  AdministratePlayersFilter _filter = AdministratePlayersFilter.active;

  Stream<List<Player>> _getPlayerStream() {
    return switch (_filter) {
      AdministratePlayersFilter.active => Player.getAllActivePlayersStream(),
      AdministratePlayersFilter.deleted => Player.getAllDeletedPlayersStream(),
      AdministratePlayersFilter.all => Player.getAllPlayersStream(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: ScreenScaffold(
        showBackgroundImage: false,
        addTopPadding: true,
        title: CustomTextTitle('Spillere'),
        backgroundColor: AppColors.dialogBackgroundColor,
        actions: [
          CustomIconButton(
            icon: Icons.add,
            size: CustomIconSize.l,
            onPressed: () async {
              final PlayerDialogResult? result = await PlayerDialog.show(context);

              if (result != null && result.name.trim().isNotEmpty) {
                final newPlayer = Player.createNewPlayer(name: result.name, sex: result.sex);
                newPlayer.save();
              }
            },
          ),
        ],
        leading: CustomIconButton(
          size: CustomIconSize.m,
          icon: Icons.arrow_back_ios_new,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AdministratePlayersDialogFilterMenu(
                      selectedFilter: _filter,
                      onFilterSelected: (selectedFilter) {
                        setState(() {
                          _filter = selectedFilter;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            StreamBuilder(
              stream: _getPlayerStream(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }
                final allPlayers = asyncSnapshot.data!;
                return ListView.separated(
                  separatorBuilder: (context, index) => ListViewSeparator(),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allPlayers.length,
                  itemBuilder: (context, index) {
                    final item = allPlayers[index];
                    return PlayerEditList(item: item);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
