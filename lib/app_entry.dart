import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkeborgcano/l10n/app_localizations.dart';
import 'package:silkeborgcano/router.dart';

BuildContext? buildContext;
AppLocalizations? appLocalizations;

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(textTheme: GoogleFonts.latoTextTheme(textTheme)),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // add this code
      supportedLocales: const [
        Locale('da'), // English
      ],
      onGenerateTitle: (context) {
        buildContext = context;
        appLocalizations = AppLocalizations.of(context);
        return 'SilkeborgCaron';
      },
    );
  }
}
