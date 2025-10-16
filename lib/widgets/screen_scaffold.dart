import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? floatingActionButton;
  final VoidCallback? onHomeTap;
  final Color? backgroundColor;
  final bool showBackgroundImage;
  const ScreenScaffold({
    super.key,
    this.title,
    this.actions,
    this.leading,
    required this.body,
    this.floatingActionButton,
    this.onHomeTap,
    this.backgroundColor,
    this.showBackgroundImage = true,
  });

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: AppSizes.xs, right: AppSizes.xs, bottom: AppSizes.xs),
      child: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.scaffoldBackgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      extendBodyBehindAppBar: showBackgroundImage,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: title,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
          fontFamily: GoogleFonts.jersey25().fontFamily,
          letterSpacing: 0.5,
        ),
        centerTitle: true,
        actions: actions,
        leading: leading ?? CustomIconButton(icon: Symbols.home, onPressed: onHomeTap, size: CustomIconSize.m),
      ),
      body: showBackgroundImage
          ? DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(AppColors.scaffoldBackgroundColor.withAlpha(70), BlendMode.dstATop),
                ),
              ),
              child: SafeArea(child: _getBody()),
            )
          : _getBody(),
    );
  }
}
