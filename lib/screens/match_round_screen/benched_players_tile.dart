import 'package:flutter/material.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

class BenchedPlayersTile extends StatelessWidget {
  final List<Player> players;
  const BenchedPlayersTile({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.driftwoodGray,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                child: Text(
                  'Sidder over',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.oceanWave,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Text(player.name, style: TextStyle(color: Colors.white, fontSize: 16));
            },
          ),
        ),
      ],
    );
  }
}
