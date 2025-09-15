import 'package:flutter/material.dart';
import 'package:silkeborgcano/models/player.dart';

class AdministrateMatchRoundPlayersDialog extends StatefulWidget {
  final List<Player> allMatchPlayers;
  final List<Player> selectedPlayers;
  const AdministrateMatchRoundPlayersDialog({
    super.key,
    required this.allMatchPlayers,
    required this.selectedPlayers,
  });

  static Future<List<Player>?> show(
    BuildContext context, {
    List<Player> allMatchPlayers = const [],
    List<Player> selectedPlayers = const [],
  }) {
    return showDialog<List<Player>?>(
      context: context,
      builder: (context) => AdministrateMatchRoundPlayersDialog(
        allMatchPlayers: allMatchPlayers,
        selectedPlayers: selectedPlayers,
      ),
    );
  }

  @override
  State<AdministrateMatchRoundPlayersDialog> createState() =>
      _AdministrateMatchRoundPlayersDialogState();
}

class _AdministrateMatchRoundPlayersDialogState
    extends State<AdministrateMatchRoundPlayersDialog> {
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
          title: Text('Spillere'),
          centerTitle: true,
          forceMaterialTransparency: true,
          actions: [],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: widget.allMatchPlayers.length,
          itemBuilder: (context, index) {
            final item = widget.allMatchPlayers.elementAt(index);

            return ListTile(
              title: Text(item.name),
              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.face)),
            );
          },
        ),
      ),
    );
  }
}
