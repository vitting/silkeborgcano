import 'package:flutter/material.dart';
import 'package:silkeborgcano/dialogs/default_dialog.dart';
import 'package:silkeborgcano/mixins/vibrate_mixin.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

enum RegisterPointsDialogTeamEnum { team1, team2 }

class RegisterPointsDialog extends StatefulWidget {
  final int initialValue;
  final RegisterPointsDialogTeamEnum team;
  final String? player1Name;
  final String? player2Name;
  final int maxPoints;
  final Color backgroundColor;
  final bool isValueSelected;
  const RegisterPointsDialog({
    super.key,
    this.initialValue = 0,
    required this.team,
    required this.backgroundColor,
    this.maxPoints = 21,
    this.player1Name,
    this.player2Name,
    this.isValueSelected = false,
  });

  static Future<int?> show(
    BuildContext context, {
    int initialValue = 0,
    required RegisterPointsDialogTeamEnum team,
    required int maxPoints,
    String? player1Name,
    String? player2Name,
    required Color backgroundColor,
    bool isValueSelected = false,
  }) {
    return showDialog<int?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => RegisterPointsDialog(
        initialValue: initialValue,
        team: team,
        maxPoints: maxPoints,
        player1Name: player1Name,
        player2Name: player2Name,
        backgroundColor: backgroundColor,
        isValueSelected: isValueSelected,
      ),
    );
  }

  @override
  State<RegisterPointsDialog> createState() => _RegisterPointsDialogState();
}

class _RegisterPointsDialogState extends State<RegisterPointsDialog> with VibrateMixin {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue == 0 ? '' : widget.initialValue.toString());
  }

  String _getTitle() {
    if (widget.team == RegisterPointsDialogTeamEnum.team1) {
      return 'Vælg points for hold 1';
    } else {
      return 'Vælg points for hold 2';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: _getTitle(),
      children: [
        GridView.builder(
          itemCount: widget.maxPoints + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int number = index;
            bool isSelectedInitial = widget.initialValue == number;
            return InkWell(
              customBorder: CircleBorder(),
              radius: 23,
              splashColor: AppColors.dialogBackgroundColor,
              onTap: () {
                vibrateShort();

                if (context.mounted) {
                  Navigator.of(context).pop(number);
                }
              },

              child: Ink(
                decoration: BoxDecoration(
                  color: isSelectedInitial && widget.isValueSelected
                      ? widget.backgroundColor.withValues(red: 50)
                      : widget.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(child: CustomText(data: number.toString())),
              ),
            );
          },
        ),
      ],
    );
  }
}
