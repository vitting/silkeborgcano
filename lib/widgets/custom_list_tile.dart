import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';

class CustomListTile extends StatelessWidget {
  final Widget child;
  final Color tileColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final bool dense;
  final Color? leadingIndicatorColor;

  const CustomListTile({
    super.key,
    required this.child,
    this.tileColor = AppColors.tileBackground,
    this.onTap,
    this.subtitle,
    this.trailing,
    this.leading,
    this.onLongPress,
    this.dense = false,
    this.leadingIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: AppSizes.elevation,
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.s, vertical: AppSizes.xxs),
            dense: dense,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderSize),
              side: BorderSide(color: AppColors.tileBorderColor, width: AppSizes.borderWidth),
            ),
            title: child,
            tileColor: tileColor,
            onTap: onTap,
            subtitle: subtitle,
            trailing: trailing,
            leading: leading,
            onLongPress: onLongPress,
          ),
          if (leadingIndicatorColor != null)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: leadingIndicatorColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.borderSize),
                    bottomLeft: Radius.circular(AppSizes.borderSize),
                  ),
                ),
                // height: 56,
                height: double.infinity,
                width: AppSizes.xs,
              ),
            ),
        ],
      ),
    );
  }
}
