import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final CustomIconSize size;
  final Widget? stackedIcon;
  final bool showBackground;
  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.size = CustomIconSize.l,
    this.stackedIcon,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showBackground
          ? BoxDecoration(
              color: onPressed != null ? AppColors.buttonBackgroundColor : AppColors.buttonBackgroundColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            )
          : null,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: onPressed != null
            ? CustomIcon(icon, size: size, stackedIcon: stackedIcon)
            : CustomIcon(icon, color: AppColors.iconDisabled, size: size, stackedIcon: stackedIcon),
      ),
    );
  }
}
