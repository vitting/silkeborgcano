import 'package:flutter/material.dart';

class MatchListTileTitle extends StatelessWidget {
  final int court;
  const MatchListTileTitle({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bane $court',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
