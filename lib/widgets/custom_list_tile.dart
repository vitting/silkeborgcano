import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final Widget child;
  final Color tileColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final bool dense;

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
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      // elevation: 3,
      child: ListTile(
        dense: dense,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: child,
        tileColor: tileColor,
        onTap: onTap,
        subtitle: subtitle,
        trailing: trailing,
        leading: leading,
        onLongPress: onLongPress,
      ),
    );
  }
}
