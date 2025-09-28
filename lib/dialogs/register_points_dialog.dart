import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/dialogs/default_dialog.dart';
import 'package:silkeborgcano/widgets/custom_text_form_field.dart';

enum RegisterPointsDialogTeamEnum { team1, team2 }

class RegisterPointsDialog extends StatefulWidget {
  final int initialValue;
  final RegisterPointsDialogTeamEnum team;
  final String? player1Name;
  final String? player2Name;
  final int maxPoints;
  const RegisterPointsDialog({
    super.key,
    this.initialValue = 0,
    required this.team,
    this.maxPoints = 21,
    this.player1Name,
    this.player2Name,
  });

  static Future<int?> show(
    BuildContext context, {
    int initialValue = 0,
    required RegisterPointsDialogTeamEnum team,
    required int maxPoints,
    String? player1Name,
    String? player2Name,
  }) {
    return showDialog<int?>(
      context: context,
      builder: (context) => RegisterPointsDialog(
        initialValue: initialValue,
        team: team,
        maxPoints: maxPoints,
        player1Name: player1Name,
        player2Name: player2Name,
      ),
    );
  }

  @override
  State<RegisterPointsDialog> createState() => _RegisterPointsDialogState();
}

class _RegisterPointsDialogState extends State<RegisterPointsDialog> {
  late final TextEditingController controller;
  String? errorText;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue == 0 ? '' : widget.initialValue.toString());
  }

  void _validateInput(String input) {
    int points = int.tryParse(controller.text) ?? 0;
    if (points > widget.maxPoints) {
      setState(() {
        errorText = 'Maksimum point er ${widget.maxPoints}';
      });
    } else {
      context.pop<int>(int.tryParse(controller.text) ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      children: [
        if (widget.team == RegisterPointsDialogTeamEnum.team1) Text('Points for hold 1'),
        if (widget.team == RegisterPointsDialogTeamEnum.team2) Text('Points for hold 2'),
        if (widget.player1Name != null && widget.player2Name != null) ...[
          Gap(8),
          Text('${widget.player1Name} / ${widget.player2Name}'),
        ],
        Text('Indtast point (max ${widget.maxPoints})'),
        Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              child: CustomTextFormField(
                controller: controller,
                behavior: CustomTextFormFieldBehavior.number,
                onFieldSubmitted: (_) {
                  _validateInput(controller.text);
                },
                onChanged: (value) {
                  debugPrint('value: $value');
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(errorText ?? '', style: TextStyle(color: Colors.red))],
        ),
        Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Fortryd'),
            ),
            ElevatedButton(
              onPressed: () {
                _validateInput(controller.text);
              },
              child: Text('Gem'),
            ),
          ],
        ),
      ],
    );
  }
}
