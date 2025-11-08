import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/widgets/custom_text_title.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  static const String routerPath = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      showBackButton: true,
      onBackButtonTap: () {
        context.pushNamed(HomeScreen.routerPath);
      },
      title: CustomTextTitle('Indstillinger'),
      body: Container(),
    );
  }
}
