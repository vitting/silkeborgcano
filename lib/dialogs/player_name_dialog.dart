import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/widgets/custom_text_form_field.dart';

class PlayerNameDialog extends StatefulWidget {
  final String? initialValue;
  const PlayerNameDialog({super.key, this.initialValue});

  static Future<String?> show(BuildContext context, {String? initialValue}) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return PlayerNameDialog(initialValue: initialValue);
      },
    );
  }

  @override
  State<PlayerNameDialog> createState() => _PlayerNameDialogState();
}

class _PlayerNameDialogState extends State<PlayerNameDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              initialValue: widget.initialValue,
              controller: controller,
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
                    context.pop(controller.text);
                  },
                  child: Text('Gem'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
