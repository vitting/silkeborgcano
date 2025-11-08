import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/settings_screen/settings_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';

Page<dynamic> customTransitionPage(BuildContext context, GoRouterState state, Widget screen) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: screen,
    transitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      // Change the opacity of the screen using a Curve based on the the animation's
      // value
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

// GoRouter configuration
final router = GoRouter(
  // initialLocation: TournamentScreen.routerPath,
  initialLocation: HomeScreen.routerPath,
  routes: [
    GoRoute(
      path: HomeScreen.routerPath,
      name: HomeScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, HomeScreen()),
    ),
    GoRoute(
      path: TournamentScreen.routerPath,
      name: TournamentScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, TournamentScreen()),
    ),
    GoRoute(
      path: MatchRoundScreen.routerPath,
      name: MatchRoundScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, MatchRoundScreen()),
    ),
    GoRoute(
      path: MatchesScreen.routerPath,
      name: MatchesScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, MatchesScreen()),
    ),
    GoRoute(
      path: MatchSummaryScreen.routerPath,
      name: MatchSummaryScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, MatchSummaryScreen()),
    ),
    GoRoute(
      path: TournamentSummaryScreen.routerPath,
      name: TournamentSummaryScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, TournamentSummaryScreen()),
    ),
    GoRoute(
      path: SettingsScreen.routerPath,
      name: SettingsScreen.routerPath,
      pageBuilder: (context, state) => customTransitionPage(context, state, SettingsScreen()),
    ),
  ],
);
