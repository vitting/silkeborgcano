import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/player_dialog.dart';
import 'package:silkeborgcano/models/player.dart';

class PlayerEditList extends StatefulWidget {
  final Player item;
  const PlayerEditList({super.key, required this.item});

  @override
  State<PlayerEditList> createState() => _PlayerEditListState();
}

class _PlayerEditListState extends State<PlayerEditList> {
  bool _showDetails = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.item.name),
          onTap: () {
            setState(() {
              _showDetails = !_showDetails;
            });
          },
          trailing: widget.item.isDeleted
              ? IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: () {
                    widget.item.save(isDeleted: false);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    widget.item.save(isDeleted: true);
                  },
                ),
          onLongPress: () async {
            final result = await PlayerDialog.show(
              context,
              initialValue: widget.item.name,
            );
            if (result != null && result.name.trim().isNotEmpty) {
              widget.item.save(name: result.name, sex: result.sex);
            }
          },
        ),
        if (_showDetails)
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Køn:'),
                    DropdownMenu(
                      initialSelection: widget.item.sex,
                      onSelected: (value) {},
                      dropdownMenuEntries: [
                        DropdownMenuEntry(label: 'Mand', value: 'm'),
                        DropdownMenuEntry(label: 'Kvinde', value: 'k'),
                        DropdownMenuEntry(label: 'Ukendt', value: 'u'),
                      ],
                    ),
                  ],
                ),
                Row(children: [Text('Point:'), Text('${widget.item.points}')]),
              ],
            ),
          ),
      ],
    );
  }
}
