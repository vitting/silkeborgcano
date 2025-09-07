import 'package:flutter/material.dart';

class DeleteTournamentDialog extends StatelessWidget {
  const DeleteTournamentDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (context) => DeleteTournamentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Vil du slette turneringen?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Fortryd'),
        ),
        TextButton(
          onPressed: () {
            // Delete action
            Navigator.of(context).pop(true);
          },
          child: Text('Slet'),
        ),
      ],
    );
  }
}
