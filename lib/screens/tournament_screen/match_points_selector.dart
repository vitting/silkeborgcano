import 'package:flutter/material.dart';

class MatchPointsSelector extends StatelessWidget {
  final int? initialPointPerMatch;
  final ValueChanged<int?> onChanged;
  const MatchPointsSelector({
    super.key,
    this.initialPointPerMatch,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<int>(
      groupValue: initialPointPerMatch,
      onChanged: onChanged,
      child: Row(
        children: [
          Flexible(
            child: RadioListTile(value: 11, title: Text('11'), dense: true),
          ),
          Flexible(
            child: RadioListTile(value: 15, title: Text('15'), dense: true),
          ),
          Flexible(
            child: RadioListTile(value: 21, title: Text('21'), dense: true),
          ),
        ],
      ),
    );
  }
}
