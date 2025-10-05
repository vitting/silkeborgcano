import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? floatingActionButton;
  const ScreenScaffold({super.key, this.title, this.actions, this.leading, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 243, 250, 189),
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: title,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellow.shade900),
        centerTitle: true,
        actions: actions,
        leading:
            leading ??
            IconButton(
              icon: Icon(Symbols.home, size: 32, color: Colors.yellow.shade900, fontWeight: FontWeight.w300, fill: 1),
              onPressed: () {
                context.goNamed(HomeScreen.routerPath);
              },
            ),
      ),
      body: Padding(padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0), child: body),
    );
  }
}
