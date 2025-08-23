import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/screens/home_screen.dart';
import 'package:silkeborgcano/screens/tournament_screen.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: TournamentScreen.routerPath,
  // initialLocation: HomeScreen.routerPath,
  routes: [
    GoRoute(
      path: HomeScreen.routerPath,
      name: HomeScreen.routerPath,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: TournamentScreen.routerPath,
      name: TournamentScreen.routerPath,
      builder: (context, state) => TournamentScreen(),
    ),
  ],
);
