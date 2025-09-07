import 'package:flutter/material.dart';
import 'package:silkeborgcano/models/player.dart';

class ChosePlayerDialog extends StatefulWidget {
  final List<Player> players;
  final List<Player> selectedPlayers;
  const ChosePlayerDialog({
    super.key,
    required this.players,
    this.selectedPlayers = const [],
  });

  static Future<List<Player>?> show(
    BuildContext context,
    List<Player> players,
    List<Player> selectedPlayers,
  ) {
    return showDialog<List<Player>?>(
      context: context,
      builder: (context) =>
          ChosePlayerDialog(players: players, selectedPlayers: selectedPlayers),
    );
  }

  @override
  State<ChosePlayerDialog> createState() => _ChosePlayerDialogState();
}

class _ChosePlayerDialogState extends State<ChosePlayerDialog> {
  final Set<Player> _selectedPlayers = {};
  final Set<String> _selectedPlayerIds = {};

  @override
  void initState() {
    super.initState();

    _selectedPlayers.addAll(widget.selectedPlayers);
    _selectedPlayerIds.addAll(
      widget.selectedPlayers.map((player) => player.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vælg spillere'),
          centerTitle: true,
          forceMaterialTransparency: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop(_selectedPlayers.toList());
            },
          ),
        ),
        body: ListView.builder(
          itemCount: widget.players.length,
          itemBuilder: (context, index) {
            final item = widget.players[index];
            return CheckboxListTile(
              value: _selectedPlayerIds.contains(item.id),
              selected: _selectedPlayerIds.contains(item.id),
              selectedTileColor: Colors.black.withValues(alpha: 0.1),
              title: Text(item.name),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedPlayers.add(item);
                    _selectedPlayerIds.add(item.id);
                  } else {
                    _selectedPlayers.remove(item);
                    _selectedPlayerIds.remove(item.id);
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}
