import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';

class MatchListTilePoints extends StatelessWidget {
  final int pointsTeam1;
  final int pointsTeam2;
  const MatchListTilePoints({super.key, required this.pointsTeam1, required this.pointsTeam2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: 'Tryk på et hold for at registrere points',
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.matchTilePointsBackgroundColor,
              borderRadius: BorderRadius.circular(AppSizes.borderSize),
            ),
            child: Text(
              '$pointsTeam1 : $pointsTeam2',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
