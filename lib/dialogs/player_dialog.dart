import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/dialogs/default_dialog.dart';
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
      children: [
        Text('Navn'),
        Gap(16),
        CustomTextFormField(controller: controller),
        Gap(16),
        Text('Køn'),
        RadioGroup<String>(
          groupValue: _sex,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _sex = value;
            });
          },
          child: Column(
            children: [
              RadioListTile(value: 'u', title: Text('Ikke opgivet'), dense: true),
              RadioListTile(value: 'f', title: Text('Kvinde'), dense: true),
              RadioListTile(value: 'm', title: Text('Mand'), dense: true),
            ],
          ),
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
                context.pop<PlayerDialogResult>(PlayerDialogResult(name: controller.text.trim(), sex: _sex));
              },
              child: Text('Gem'),
            ),
          ],
        ),
      ],
    );
  }
}
