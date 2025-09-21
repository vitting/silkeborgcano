import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkeborgcano/router.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(textTheme: GoogleFonts.latoTextTheme(textTheme)),
    );
  }
}
