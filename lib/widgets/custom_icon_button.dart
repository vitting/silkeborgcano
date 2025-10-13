import 'package:flutter/material.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final CustomIconSize size;
  const CustomIconButton({super.key, this.onPressed, required this.icon, this.tooltip, this.size = CustomIconSize.l});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: onPressed != null ? CustomIcon(icon, size: size) : CustomIcon(icon, color: AppColors.iconDisabled, size: size),
    );
  }
}
