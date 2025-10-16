import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/player_dialog.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/objectbox.g.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_checkbox_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/list_view_separator.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class ChosePlayerDialog extends StatefulWidget {
  final List<Player> selectedPlayers;
  const ChosePlayerDialog({super.key, this.selectedPlayers = const []});

  static Future<List<Player>?> show(BuildContext context, List<Player> selectedPlayers) {
    return showDialog<List<Player>?>(
      useSafeArea: false,
      context: context,
      builder: (context) => ChosePlayerDialog(selectedPlayers: selectedPlayers),
    );
  }

  @override
  State<ChosePlayerDialog> createState() => _ChosePlayerDialogState();
}

class _ChosePlayerDialogState extends State<ChosePlayerDialog> {
  final Map<String, Player> _selectedPlayers = {};

  @override
  void initState() {
    super.initState();

    for (var player in widget.selectedPlayers) {
      _selectedPlayers[player.id] = player;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: ScreenScaffold(
        showBackgroundImage: false,
        title: Text('Vælg spillere (${_selectedPlayers.length})'),
        backgroundColor: AppColors.dialogBackgroundColor,
        actions: [
          CustomIconButton(
            size: CustomIconSize.m,
            icon: Icons.add,
            onPressed: () async {
              final result = await PlayerDialog.show(context);

              if (result != null && result.name.trim().isNotEmpty) {
                final newPlayer = Player.createNewPlayer(name: result.name);
                newPlayer.save();
                _selectedPlayers[newPlayer.id] = newPlayer;
              }
            },
          ),
        ],
        leading: CustomIconButton(
          size: CustomIconSize.m,
          icon: Icons.arrow_back_ios_new,
          onPressed: () {
            Navigator.of(context).pop(_selectedPlayers.values.toList());
          },
        ),
        body: StreamBuilder(
          stream: objectbox.store
              .box<Player>()
              .query(Player_.isDeleted.equals(false))
              .order(Player_.name)
              .watch(triggerImmediately: true)
              .map((query) => query.find()),
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
              itemCount: allPlayers.length,
              itemBuilder: (context, index) {
                final item = allPlayers[index];
                return GestureDetector(
                  onLongPress: () async {
                    final result = await PlayerDialog.show(context, initialValue: item.name);
                    if (result != null && result.name.trim().isNotEmpty) {
                      item.save(name: result.name, sex: result.sex);
                      if (_selectedPlayers.containsKey(item.id)) {
                        _selectedPlayers[item.id] = item;
                      }
                    }
                  },
                  child: CustomCheckboxListTile(
                    value: _selectedPlayers.keys.contains(item.id),
                    selected: _selectedPlayers.keys.contains(item.id),
                    title: CustomText(data: item.name, size: CustomTextSize.s),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedPlayers[item.id] = item;
                        } else {
                          _selectedPlayers.remove(item.id);
                        }
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
