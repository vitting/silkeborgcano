import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/dialogs/register_points_dialog.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';
import 'package:silkeborgcano/screens/match_summary_screen/match_summary_screen.dart';

class MatchesScreen extends StatefulWidget {
  static const String routerPath = "/matches";
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  MatchRound? _matchRound;
  List<Match> _matches = [];
  int _pointPerMatch = 21;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_matchRound == null) {
      final MatchRound? matchRound = GoRouterState.of(context).extra as MatchRound?;
      if (matchRound == null) {
        debugPrint('**************MatchRound can\'t be null');
        return;
      }

      final Tournament tournament = matchRound.getTournament();
      _pointPerMatch = tournament.pointPerMatch;

      _matchRound = matchRound;
      _matches = matchRound.matches;
    }
  }

  ({int team1, int team2}) _calculatePointsForMatch(int team1Points, int team2Points) {
    int team1Score = 0;
    int team2Score = 0;
    if (team1Points != 0) {
      team1Score = team1Points;
      team2Score = _pointPerMatch - team1Points;
    }

    if (team2Points != 0) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Runde ${_matchRound?.roundIndex ?? ''}'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed(HomeScreen.routerPath);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!_validateThatAllMatchesHaveScore()) {
                  await YesNoDialog.show(
                    context,
                    title: 'Før du kan afslutte en runde skal alle kampe have indtastet en score',
                    yesButtonText: 'Ok',
                  );
                  return;
                }
                _matchRound?.endRound();

                if (mounted) {
                  context.goNamed(MatchSummaryScreen.routerPath, extra: _matchRound);
                }
              },
              child: Text('Afslut runde'),
            ),
            Expanded(
              child: ListView.separated(
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
                      );

                      if (result != null) {
                        final score = _calculatePointsForMatch(result, 0);
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
                      );

                      if (result != null) {
                        final score = _calculatePointsForMatch(0, result);
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
            ),
          ],
        ),
      ),
    );
  }
}
