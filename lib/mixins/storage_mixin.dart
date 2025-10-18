import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/tournament_summary_screen/tournament_summary_screen.dart';

mixin StorageMixin {
  Tournament? getTournamentById(BuildContext context, {bool throwErrorOnNull = false}) {
    final String? tournamentId = GoRouterState.of(context).extra as String?;
    if (tournamentId == null) {
      if (throwErrorOnNull) {
        debugPrint('**************tournamentId can\'t be null');
        throw Exception('tournamentId can\'t be null');
      }

      return null;
    }

    return Tournament.getById(tournamentId);
  }

  MatchRound? getMatchRoundById(BuildContext context, {bool throwErrorOnNull = false}) {
    final String? matchRoundId = GoRouterState.of(context).extra as String?;
    if (matchRoundId == null) {
      if (throwErrorOnNull) {
        debugPrint('**************matchRoundId can\'t be null');
        throw Exception('matchRoundId can\'t be null');
      }

      return null;
    }

    return MatchRound.getById(matchRoundId);
  }

  TournamentSummaryScreenRouteParams? getTournamentSummaryScreenRouteParams(
    BuildContext context, {
    bool throwErrorOnNull = false,
  }) {
    final params = GoRouterState.of(context).extra as TournamentSummaryScreenRouteParams?;
    if (params == null) {
      if (throwErrorOnNull) {
        debugPrint('**************TournamentSummaryScreenRouteParams can\'t be null');
        throw Exception('TournamentSummaryScreenRouteParams can\'t be null');
      }

      return null;
    }

    return params;
  }
}
