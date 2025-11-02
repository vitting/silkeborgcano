import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/player_dialog.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class PlayerEditList extends StatefulWidget {
  final Player item;
  const PlayerEditList({super.key, required this.item});

  @override
  State<PlayerEditList> createState() => _PlayerEditListState();
}

class _PlayerEditListState extends State<PlayerEditList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomListTile(
          trailing: widget.item.isDeleted
              ? CustomIconButton(
                  icon: Icons.restore,
                  size: CustomIconSize.m,
                  onPressed: () {
                    widget.item.save(isDeleted: false);
                  },
                )
              : CustomIconButton(
                  icon: Icons.delete,
                  size: CustomIconSize.m,
                  onPressed: () {
                    widget.item.save(isDeleted: true);
                  },
                ),
          onLongPress: () async {
            final result = await PlayerDialog.show(context, initialValue: widget.item.name);
            if (result != null && result.name.trim().isNotEmpty) {
              widget.item.save(name: result.name, sex: result.sex);
            }
          },
          child: CustomText(widget.item.name),
        ),
      ],
    );
  }
}
