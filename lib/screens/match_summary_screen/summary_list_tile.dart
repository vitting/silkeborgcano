import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class SummaryListTile extends StatelessWidget {
  final String playerName;
  final int points;
  final bool isSittingOver;
  final Color? leadingIndicatorColor;

  const SummaryListTile({
    super.key,
    required this.playerName,
    required this.points,
    this.isSittingOver = false,
    this.leadingIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leadingIndicatorColor: isSittingOver ? AppColors.summaryListTileSittingOverBackgroundColor : null,
      tileColor: AppColors.summaryListTileBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: CustomText(playerName, size: CustomTextSize.m)),
          const Gap(AppSizes.xs),
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs, vertical: AppSizes.xxs),
            decoration: BoxDecoration(color: AppColors.darkPurple, borderRadius: BorderRadius.circular(AppSizes.borderSize)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText('$points', size: CustomTextSize.m),
                const Gap(AppSizes.xs),
                CustomIcon(Symbols.trophy, size: CustomIconSize.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
