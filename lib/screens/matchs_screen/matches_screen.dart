import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:silkeborgcano/dialogs/register_points_dialog.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/mixins/storage_mixin.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/custom_floating_action_button.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class MatchesScreen extends StatefulWidget {
  static const String routerPath = "/matches";
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> with StorageMixin {
  MatchRound? _matchRound;
  List<Match> _matches = [];
  int _pointPerMatch = 21;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_matchRound == null) {
      _matchRound = getMatchRoundById(context, throwErrorOnNull: true);

      final Tournament tournament = _matchRound!.getTournament();
      _pointPerMatch = tournament.pointPerMatch;
      _matches = _matchRound!.matches;
    }
  }

  ({int team1, int team2}) _calculatePointsForMatch(int team1Points, int team2Points) {
    int team1Score = 0;
    int team2Score = 0;

    if (team1Points == 0 || team2Points == 0) {
      return (team1: team1Points == 0 ? 0 : _pointPerMatch, team2: team2Points == 0 ? 0 : _pointPerMatch);
    }

    if (team1Points > 0) {
      team1Score = team1Points;
      team2Score = _pointPerMatch - team1Points;
    }

    if (team2Points > 0) {
      team2Score = team2Points;
      team1Score = _pointPerMatch - team2Points;
    }

    return (team1: team1Score, team2: team2Score);
  }

  bool _validateThatAllMatchesHaveScore() {
    for (final m in _matches) {
      if (!m.hasScore) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: Text('Runde ${_matchRound?.roundIndex}'),
      onHomeTap: () {
        context.goNamed(HomeScreen.routerPath);
      },
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () async {
          if (!_validateThatAllMatchesHaveScore()) {
            await YesNoDialog.show(
              context,
              title: 'Alle kampe skal have en score',
              body: 'Før du kan afslutte en runde skal alle kampe have indtastet en score',
              yesButtonText: 'Ok',
            );
            return;
          }
          _matchRound?.endRound();

          if (mounted) {
            context.goNamed(MatchSummaryScreen.routerPath, extra: _matchRound!.id);
          }
        },
        icon: Symbols.check,
        tooltip: 'Afslut runde',
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final m = _matches[index];
          return MatchListTile(
            court: m.courtNumber,
            team1: m.team1,
            team2: m.team2,
            pointsTeam1: m.team1Score,
            pointsTeam2: m.team2Score,
            onTapTeam1: () async {
              final result = await RegisterPointsDialog.show(
                context,
                team: RegisterPointsDialogTeamEnum.team1,
                initialValue: m.team1Score,
                maxPoints: _pointPerMatch,
                player1Name: m.team1[0].name,
                player2Name: m.team1[1].name,
                backgroundColor: AppColors.matchTileArea1Background,
                isValueSelected: !(m.team1Score == 0 && m.team2Score == 0),
              );

              if (result != null) {
                final score = _calculatePointsForMatch(result, -1);
                setState(() {
                  m.addScore(score.team1, score.team2);
                });
              }
            },
            onTapTeam2: () async {
              final result = await RegisterPointsDialog.show(
                context,
                team: RegisterPointsDialogTeamEnum.team2,
                initialValue: m.team2Score,
                maxPoints: _pointPerMatch,
                player1Name: m.team2[0].name,
                player2Name: m.team2[1].name,
                backgroundColor: AppColors.matchTileArea2Background,
                isValueSelected: !(m.team1Score == 0 && m.team2Score == 0),
              );

              if (result != null) {
                final score = _calculatePointsForMatch(-1, result);
                setState(() {
                  m.addScore(score.team1, score.team2);
                });
              }
            },
            showPoints: true,
          );
        },
        separatorBuilder: (context, index) => Gap(8),
        itemCount: _matches.length,
      ),
    );
  }
}
