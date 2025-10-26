import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class MatchSummaryInfoCard extends StatelessWidget {
  final String matchTime;
  final bool showSittingOverIndicator;
  final int roundIndex;
  const MatchSummaryInfoCard({
    super.key,
    required this.matchTime,
    this.showSittingOverIndicator = false,
    required this.roundIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.matchSummaryInfoCardBackgorundColor,
      shadowColor: AppColors.matchSummaryInfoCardBorderColor,
      margin: EdgeInsets.zero,
      elevation: AppSizes.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderSize),
        side: BorderSide(color: AppColors.matchSummaryInfoCardBorderColor, width: AppSizes.borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xs),
        child: Column(
          children: [
            CustomText('Runde $roundIndex'),
            const Gap(AppSizes.xxs),
            CustomText(matchTime),
            const Gap(AppSizes.xxs),
            if (showSittingOverIndicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.summaryListTileSittingOverBackgroundColor,
                    ),
                  ),
                  Gap(AppSizes.xs),
                  CustomText('Sad over denne runde'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
