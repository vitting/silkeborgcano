import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/dialogs/default_dialog.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_primary_button.dart';
import 'package:silkeborgcano/widgets/custom_radio_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_secondary_button.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/custom_text_form_field.dart';

class PlayerDialogResult {
  final String name;
  final String sex;

  PlayerDialogResult({required this.name, required this.sex});
}

class PlayerDialog extends StatefulWidget {
  final String? initialValue;
  final String initialSex;
  const PlayerDialog({super.key, this.initialValue, this.initialSex = 'u'});

  static Future<PlayerDialogResult?> show(BuildContext context, {String? initialValue}) {
    return showDialog<PlayerDialogResult?>(
      context: context,
      builder: (context) {
        return PlayerDialog(initialValue: initialValue);
      },
    );
  }

  @override
  State<PlayerDialog> createState() => _PlayerDialogState();
}

class _PlayerDialogState extends State<PlayerDialog> {
  late final TextEditingController controller;
  late String _sex;

  @override
  void initState() {
    super.initState();
    _sex = widget.initialSex;
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: 'Spiller',
      children: [
        CustomText(data: 'Navn'),
        Gap(AppSizes.xs),
        CustomTextFormField(controller: controller),
        Gap(AppSizes.s),
        // CustomText(data: 'Køn'),
        // RadioGroup<String>(
        //   groupValue: _sex,
        //   onChanged: (value) {
        //     if (value == null) return;
        //     setState(() {
        //       _sex = value;
        //     });
        //   },
        //   child: Column(
        //     children: [
        //       CustomRadioListTile(value: 'u', title: 'Ikke opgivet'),
        //       CustomRadioListTile(value: 'f', title: 'Kvinde'),
        //       CustomRadioListTile(value: 'm', title: 'Mand'),
        //     ],
        //   ),
        // ),
        // Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSecondaryButton(
              onPressed: () {
                context.pop();
              },
              text: 'Fortryd',
            ),
            CustomPrimaryButton(
              onPressed: () {
                context.pop<PlayerDialogResult>(PlayerDialogResult(name: controller.text.trim(), sex: _sex));
              },
              text: 'Gem',
            ),
          ],
        ),
      ],
    );
  }
}
