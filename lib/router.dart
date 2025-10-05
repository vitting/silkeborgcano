import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_round_screen.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';
import 'package:silkeborgcano/screens/matchs_screen/matches_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';

// GoRouter configuration
final router = GoRouter(
  // initialLocation: TournamentScreen.routerPath,
  initialLocation: HomeScreen.routerPath,
  routes: [
    GoRoute(path: HomeScreen.routerPath, name: HomeScreen.routerPath, builder: (context, state) => HomeScreen()),
    GoRoute(
      path: TournamentScreen.routerPath,
      name: TournamentScreen.routerPath,
      builder: (context, state) => TournamentScreen(),
    ),
    GoRoute(
      path: MatchRoundScreen.routerPath,
      name: MatchRoundScreen.routerPath,
      builder: (context, state) => MatchRoundScreen(),
    ),
    GoRoute(path: MatchesScreen.routerPath, name: MatchesScreen.routerPath, builder: (context, state) => MatchesScreen()),
    GoRoute(
      path: MatchSummaryScreen.routerPath,
      name: MatchSummaryScreen.routerPath,
      builder: (context, state) => MatchSummaryScreen(),
    ),
    GoRoute(
      path: TournamentSummaryScreen.routerPath,
      name: TournamentSummaryScreen.routerPath,
      builder: (context, state) => TournamentSummaryScreen(),
    ),
  ],
);
