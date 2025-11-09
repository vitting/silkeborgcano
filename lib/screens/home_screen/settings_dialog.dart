import 'package:flutter/material.dart';
import 'package:silkeborgcano/mixins/vibrate_mixin.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class SettingsDialog extends StatelessWidget with VibrateMixin {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, builder: (context) => const SettingsDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: ScreenScaffold(
        backgroundColor: AppColors.dialogBackgroundColor,
        showBackgroundImage: false,
        showBackButton: true,
        addTopPadding: true,
        onBackButtonTap: () {
          vibrateShort();
          Navigator.of(context).pop();
        },
        title: CustomTextTitle('Indstillinger'),
        body: ListView(
          children: [Padding(padding: const EdgeInsets.all(16.0), child: CustomText('Her kan du tilpasse dine indstillinger.'))],
        ),
      ),
    );
  }
}
