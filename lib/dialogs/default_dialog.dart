import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomText(
                    data: title,
                    fontFamily: GoogleFonts.jersey25().fontFamily,
                    letterSpacing: 0.5,
                    size: CustomTextSize.xl,
                    textAlign: TextAlign.center,
                    height: 0.9,
                  ),
                ),
              ],
            ),
            const Gap(AppSizes.xs),
            if (subTitle != null)
              CustomText(
                data: subTitle!,
                fontFamily: GoogleFonts.jersey25().fontFamily,
                letterSpacing: 0.5,
                size: CustomTextSize.l,
              ),
            const Gap(AppSizes.xs),
            ...children,
          ],
        ),
      ),
    );
  }
}
