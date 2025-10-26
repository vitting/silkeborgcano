import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';

class DefaultDialog extends StatelessWidget {
  final String title;
  final String? subTitle;
  final List<Widget> children;
  const DefaultDialog({super.key, required this.children, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.dialogBackgroundColor,
      insetPadding: EdgeInsets.all(AppSizes.s),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderSize),
        side: BorderSide(color: AppColors.dialogBorderColor, width: AppSizes.borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Expanded(child: CustomTextTitle(title))],
            ),
            const Gap(AppSizes.xs),
            if (subTitle != null) CustomTextTitle(subTitle!),
            const Gap(AppSizes.xs),
            ...children,
          ],
        ),
      ),
    );
  }
}
