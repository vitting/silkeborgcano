import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

class SummaryListTile extends StatelessWidget {
  final String playerName;
  final int points;
  final bool isSittingOver;
  const SummaryListTile({super.key, required this.playerName, required this.points, this.isSittingOver = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(playerName, style: TextStyle(fontSize: 16, color: AppColors.white)),
          Text('$points points', style: TextStyle(fontSize: 16, color: AppColors.white)),
        ],
      ),
      tileColor: isSittingOver ? AppColors.textAndIcon1 : AppColors.textAndIcon,
    );
  }
}
