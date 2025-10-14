import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;
  final IconData? iconStacked;
  final Widget? child;
  const CustomFloatingActionButton({super.key, this.onPressed, this.tooltip, required this.icon, this.iconStacked, this.child});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onPressed,
      shape: CircleBorder(),
      elevation: 3,
      backgroundColor: AppColors.floatingActionButton,
      child: child ?? CustomIcon(icon, size: CustomIconSize.l, color: AppColors.white),
    );
  }
}
