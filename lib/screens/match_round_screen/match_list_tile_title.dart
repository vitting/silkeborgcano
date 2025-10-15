import 'package:flutter/material.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class MatchListTileTitle extends StatelessWidget {
  final int court;
  const MatchListTileTitle({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [CustomText(data: 'Bane $court', textAlign: TextAlign.center)],
    );
  }
}
