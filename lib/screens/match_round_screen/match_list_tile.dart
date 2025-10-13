import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile_area.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile_points.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile_title.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

class MatchListTile extends StatelessWidget {
  final int court;
  final List<Player> team1;
  final List<Player> team2;
  final bool showPoints;
  final VoidCallback? onTapTeam1;
  final VoidCallback? onTapTeam2;
  final int pointsTeam1;
  final int pointsTeam2;
  const MatchListTile({
    super.key,
    required this.court,
    required this.team1,
    required this.team2,
    this.showPoints = false,
    this.onTapTeam1,
    this.onTapTeam2,
    this.pointsTeam1 = 0,
    this.pointsTeam2 = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.playerCardHeader,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      MatchListTileTitle(court: court),
                      if (showPoints) const Gap(4),
                      if (showPoints) MatchListTilePoints(pointsTeam1: pointsTeam1, pointsTeam2: pointsTeam2),
                    ],
                  ),
                ),

                MatchListTileArea(
                  team1Name1: team1[0].name,
                  team1Name2: team1[1].name,
                  team2Name1: team2[0].name,
                  team2Name2: team2[1].name,
                  onTapTeam1: onTapTeam1,
                  onTapTeam2: onTapTeam2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
