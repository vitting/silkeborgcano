import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/tournament.dart';

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
}
