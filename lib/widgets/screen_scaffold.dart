import 'package:flutter/material.dart';
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
  final VoidCallback? onBackButtonTap;
  final Color? backgroundColor;
  final bool showBackgroundImage;
  final bool addTopPadding;
  final bool showBackButton;
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
    this.addTopPadding = false,
    this.showBackButton = false,
    this.onBackButtonTap,
  });

  Widget _getBody() {
    return Padding(
      padding: EdgeInsets.only(top: addTopPadding ? AppSizes.s : 0, left: AppSizes.xs, right: AppSizes.xs, bottom: AppSizes.xs),
      child: body,
    );
  }

  Widget get _getLeadingWidget {
    if (leading != null) {
      return leading!;
    } else if (showBackButton) {
      return CustomIconButton(size: CustomIconSize.m, icon: Icons.arrow_back_ios_new, onPressed: onBackButtonTap);
    } else {
      return CustomIconButton(icon: Symbols.home, onPressed: onHomeTap, size: CustomIconSize.m);
    }
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
        titleTextStyle: TextStyle(color: AppColors.textColor),
        centerTitle: true,
        actions: actions,
        leading: _getLeadingWidget,
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
