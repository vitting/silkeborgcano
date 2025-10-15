import 'package:flutter/material.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile_area_tile.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';

class MatchListTileArea extends StatelessWidget {
  final String team1Name1;
  final String team1Name2;
  final String team2Name1;
  final String team2Name2;
  final VoidCallback? onTapTeam1;
  final VoidCallback? onTapTeam2;
  final bool isTeam1Selected;
  final bool isTeam2Selected;

  const MatchListTileArea({
    super.key,
    required this.team1Name1,
    required this.team1Name2,
    required this.team2Name1,
    required this.team2Name2,
    this.onTapTeam1,
    this.onTapTeam2,
    this.isTeam1Selected = false,
    this.isTeam2Selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: MatchListTileAreaTile(
              teamName1: team1Name1,
              teamName2: team1Name2,
              onTap: onTapTeam1,
              backgroundColor: AppColors.matchTileArea1Background,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(AppSizes.borderSize)),
              isWinner: isTeam1Selected,
            ),
          ),
          Expanded(
            child: MatchListTileAreaTile(
              teamName1: team2Name1,
              teamName2: team2Name2,
              onTap: onTapTeam2,
              backgroundColor: AppColors.matchTileArea2Background,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(AppSizes.borderSize)),
              isWinner: isTeam2Selected,
            ),
          ),
        ],
      ),
    );
  }
}
