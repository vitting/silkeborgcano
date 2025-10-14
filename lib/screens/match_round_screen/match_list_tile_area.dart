import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class MatchListTileArea extends StatelessWidget {
  final String team1Name1;
  final String team1Name2;
  final String team2Name1;
  final String team2Name2;
  final VoidCallback? onTapTeam1;
  final VoidCallback? onTapTeam2;

  const MatchListTileArea({
    super.key,
    required this.team1Name1,
    required this.team1Name2,
    required this.team2Name1,
    required this.team2Name2,
    this.onTapTeam1,
    this.onTapTeam2,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              splashColor: Colors.amber,
              onTap: onTapTeam1,
              child: Ink(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.matchTileArea1Background,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(data: team1Name1),
                    const Gap(8),
                    CustomText(data: team1Name2),
                  ],
                ),
              ),
            ),
          ),
          // VerticalDivider(color: Colors.green, width: 9, thickness: 1),
          Expanded(
            child: InkWell(
              splashColor: Colors.blue,
              onTap: onTapTeam2,
              child: Ink(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.matchTileArea2Background,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(data: team2Name1),
                    const Gap(8),
                    CustomText(data: team2Name2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
