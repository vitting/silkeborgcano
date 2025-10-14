import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class MatchSummaryInfoCard extends StatelessWidget {
  final String matchTime;
  final bool showSittingOverIndicator;
  const MatchSummaryInfoCard({super.key, required this.matchTime, this.showSittingOverIndicator = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.matchSummaryInfoCardBackgorundColor,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xs),
        child: Column(
          children: [
            CustomText(data: matchTime),
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
                  Gap(8),
                  CustomText(data: 'Sad over denne runde'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
