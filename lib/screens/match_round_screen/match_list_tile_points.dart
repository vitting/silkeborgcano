import 'package:flutter/material.dart';

class MatchListTilePoints extends StatelessWidget {
  final int pointsTeam1;
  final int pointsTeam2;
  const MatchListTilePoints({super.key, required this.pointsTeam1, required this.pointsTeam2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: Text(
              '$pointsTeam1 : $pointsTeam2',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
