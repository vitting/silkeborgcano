import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? floatingActionButton;
  final VoidCallback? onHomeTap;
  const ScreenScaffold({
    super.key,
    this.title,
    this.actions,
    this.leading,
    required this.body,
    this.floatingActionButton,
    this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: title,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textAndIcon),
        centerTitle: true,
        actions: actions,
        leading:
            leading ??
            IconButton(
              icon: Icon(Symbols.home, size: 32, color: AppColors.textAndIcon, fontWeight: FontWeight.w300, fill: 1),
              onPressed: onHomeTap,
            ),
      ),
      body: Padding(padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0), child: body),
    );
  }
}
