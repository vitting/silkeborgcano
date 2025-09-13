import 'package:flutter/material.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/widgets/editable_list_tile.dart';

class SelectedPlayers extends StatelessWidget {
  final List<Player> players;
  final void Function(Player player) onDelete;
  final void Function(Player player) onTapOutsideWithEmptyValue;
  final void Function(Player, String name) onChanged;

  const SelectedPlayers({
    super.key,
    required this.players,
    required this.onDelete,
    required this.onTapOutsideWithEmptyValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: players.length,
      itemBuilder: (context, index) {
        final item = players.elementAt(index);
        return EditableListTile(
          key: ObjectKey(item),
          initialValue: item.name,
          isEditing: item.name.isEmpty,
          onTapOutside: (value) {
            if (value.isEmpty) {
              onTapOutsideWithEmptyValue(item);
            }
          },
          onChanged: (value) {
            onChanged(item, value);
          },
          onDelete: () => onDelete(item),
        );
      },
    );
  }
}
