import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/player_dialog.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/objectbox.g.dart';

class ChosePlayerDialog extends StatefulWidget {
  final List<Player> selectedPlayers;
  const ChosePlayerDialog({super.key, this.selectedPlayers = const []});

  static Future<List<Player>?> show(BuildContext context, List<Player> selectedPlayers) {
    return showDialog<List<Player>?>(
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vælg spillere'),
          centerTitle: true,
          forceMaterialTransparency: true,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                objectbox.store.box<Player>().removeAll();
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final result = await PlayerDialog.show(context);

                if (result != null && result.name.trim().isNotEmpty) {
                  final newPlayer = Player.createNewPlayer(name: result.name);
                  newPlayer.save();
                  _selectedPlayers[newPlayer.id] = newPlayer;
                }
              },
              iconSize: 28,
              color: Colors.blue,
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop(_selectedPlayers.values.toList());
            },
          ),
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
            return ListView.builder(
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
                  child: CheckboxListTile(
                    value: _selectedPlayers.keys.contains(item.id),
                    selected: _selectedPlayers.keys.contains(item.id),
                    selectedTileColor: Colors.black.withValues(alpha: 0.1),
                    title: Text(item.name),
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
