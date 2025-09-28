import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/widgets/custom_text_form_field.dart';

class RegisterPointsDialog extends StatefulWidget {
  final int initialValue;
  const RegisterPointsDialog({super.key, this.initialValue = 0});

  static Future<int?> show(BuildContext context) {
    return showDialog<int?>(context: context, builder: (context) => RegisterPointsDialog());
  }

  @override
  State<RegisterPointsDialog> createState() => _RegisterPointsDialogState();
}

class _RegisterPointsDialogState extends State<RegisterPointsDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Points hold 1'),
            Gap(16),
            CustomTextFormField(controller: controller, behavior: CustomTextFormFieldBehavior.number),
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
                    context.pop<int>(int.tryParse(controller.text) ?? 0);
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
