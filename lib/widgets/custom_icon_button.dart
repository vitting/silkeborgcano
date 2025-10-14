import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final CustomIconSize size;
  final Widget? stackedIcon;
  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.size = CustomIconSize.l,
    this.stackedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: onPressed != null
          ? CustomIcon(icon, size: size, stackedIcon: stackedIcon)
          : CustomIcon(icon, color: AppColors.iconDisabled, size: size, stackedIcon: stackedIcon),
    );
  }
}
