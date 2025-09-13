import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/player_dialog.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/objectbox.g.dart';
import 'package:silkeborgcano/screens/home_screen/player_edit_list.dart';

class AdministratePlayersDialog extends StatefulWidget {
  const AdministratePlayersDialog({super.key});

  static Future<List<Player>?> show(BuildContext context) {
    return showDialog<List<Player>?>(
      context: context,
      builder: (context) => AdministratePlayersDialog(),
    );
  }

  @override
  State<AdministratePlayersDialog> createState() =>
      _AdministratePlayersDialogState();
}

class _AdministratePlayersDialogState extends State<AdministratePlayersDialog> {
  String _activeFilter = 'active';

  Stream<List<Player>> _getPlayerStream() {
    if (_activeFilter == 'active') {
      return objectbox.store
          .box<Player>()
          .query(Player_.isDeleted.equals(false))
          .order(Player_.name)
          .watch(triggerImmediately: true)
          .map((query) => query.find());
    } else if (_activeFilter == 'deleted') {
      return objectbox.store
          .box<Player>()
          .query(Player_.isDeleted.equals(true))
          .order(Player_.name)
          .watch(triggerImmediately: true)
          .map((query) => query.find());
    } else {
      return objectbox.store
          .box<Player>()
          .query()
          .order(Player_.name)
          .watch(triggerImmediately: true)
          .map((query) => query.find());
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
              icon: Icon(Icons.add),
              onPressed: () async {
                final PlayerDialogResult? result = await PlayerDialog.show(
                  context,
                );

                if (result != null && result.name.trim().isNotEmpty) {
                  final newPlayer = Player.newPlayer(
                    name: result.name,
                    sex: result.sex,
                  );
                  newPlayer.save();
                }
              },
              iconSize: 28,
              color: Colors.blue,
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Column(
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text('Aktive'),
                      onSelected: (value) {
                        setState(() {
                          _activeFilter = 'active';
                        });
                      },
                      selected: _activeFilter.contains('active'),
                    ),
                    FilterChip(
                      label: Text('Slettede'),
                      onSelected: (value) {
                        setState(() {
                          _activeFilter = 'deleted';
                        });
                      },
                      selected: _activeFilter.contains('deleted'),
                    ),
                    FilterChip(
                      label: Text('Alle'),
                      onSelected: (value) {
                        setState(() {
                          _activeFilter = 'all';
                        });
                      },
                      selected: _activeFilter.contains('all'),
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
                return ListView.builder(
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
