import 'package:flutter/material.dart';
import 'package:silkeborgcano/widgets/custom_radio_list_tile.dart';

class MatchPointsSelector extends StatelessWidget {
  final int? initialPointPerMatch;
  final ValueChanged<int?> onChanged;
  const MatchPointsSelector({super.key, this.initialPointPerMatch, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RadioGroup<int>(
      groupValue: initialPointPerMatch,
      onChanged: onChanged,
      child: Row(
        children: [
          Flexible(child: CustomRadioListTile(value: 11, title: '11')),
          Flexible(child: CustomRadioListTile(value: 15, title: '15')),
          Flexible(child: CustomRadioListTile(value: 21, title: '21')),
        ],
      ),
    );
  }
}
