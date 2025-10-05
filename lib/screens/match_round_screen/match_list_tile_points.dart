import 'package:flutter/material.dart';

class MatchListTilePoints extends StatelessWidget {
  final int pointsTeam1;
  final int pointsTeam2;
  const MatchListTilePoints({super.key, required this.pointsTeam1, required this.pointsTeam2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$pointsTeam1 : $pointsTeam2',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
