import 'package:flutter/material.dart';

class ScreenScaffoldTitle extends StatelessWidget {
  final String title;
  const ScreenScaffoldTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
