import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
    return Row(
      children: [
        Expanded(
          child: InkWell(
            splashColor: Colors.amber.shade900,
            onTap: onTapTeam1,
            child: Ink(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(team1Name1), const Gap(8), Text(team1Name2)],
              ),
            ),
          ),
        ),
        // VerticalDivider(color: Colors.green, width: 9, thickness: 1),
        Expanded(
          child: InkWell(
            splashColor: Colors.blue.shade900,
            onTap: onTapTeam2,
            child: Ink(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(team2Name1), const Gap(8), Text(team2Name2)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
