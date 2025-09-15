import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/models/player.dart';

class MatchListTile extends StatelessWidget {
  final int court;
  final List<Player> team1;
  final List<Player> team2;
  const MatchListTile({
    super.key,
    required this.court,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Bane $court'),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.red,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Christian Vitting Nicolaisen'),
                      const Gap(8),
                      Text('Christian Vitting Nicolaisen'),
                    ],
                  ),
                ),
              ),
              // VerticalDivider(color: Colors.green, width: 9, thickness: 1),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Christian Vitting Nicolaisen'),
                      const Gap(8),
                      Text('Christian Vitting Nicolaisen'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
