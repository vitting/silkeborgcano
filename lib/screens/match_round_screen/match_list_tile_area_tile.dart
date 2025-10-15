import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class MatchListTileAreaTile extends StatelessWidget {
  final String teamName1;
  final String teamName2;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final bool isWinner;
  const MatchListTileAreaTile({
    super.key,
    required this.teamName1,
    required this.teamName2,
    this.onTap,
    required this.backgroundColor,
    this.borderRadius,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.amber,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(AppSizes.xs - 2),
          decoration: BoxDecoration(
            border: Border.all(color: isWinner ? AppColors.white.withValues(alpha: 0.5) : Colors.transparent, width: 2),
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(data: teamName1, size: CustomTextSize.ms),
              const Gap(8),
              CustomText(data: teamName2, size: CustomTextSize.ms),
            ],
          ),
        ),
      ),
    );
  }
}
