import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class SummaryListTile extends StatelessWidget {
  final String playerName;
  final int points;
  final bool isSittingOver;

  const SummaryListTile({super.key, required this.playerName, required this.points, this.isSittingOver = false});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      tileColor: isSittingOver ? AppColors.summaryListTileSittingOverBackgroundColor : AppColors.summaryListTileBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: CustomText(data: playerName)),
          CustomText(data: '$points points'),
        ],
      ),
    );
  }
}
