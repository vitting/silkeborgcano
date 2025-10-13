import 'package:flutter/material.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class BenchedPlayersTile extends StatelessWidget {
  final List<Player> players;
  const BenchedPlayersTile({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.playerCardHeader,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: CustomText(data: 'Sidder over', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.benchedPlayerCardBackground,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return CustomText(data: player.name);
              },
            ),
          ),
        ],
      ),
    );
  }
}
