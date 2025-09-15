import 'package:flutter/material.dart';
import 'package:silkeborgcano/models/player.dart';

class BenchedPlayers extends StatelessWidget {
  final List<Player> players;
  const BenchedPlayers({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Sidder over'),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.red,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Christian Vitting Nicolaisen'),
                  Text('Christian Vitting Nicolaisen'),
                  Text('Christian Vitting Nicolaisen'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
