import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/dialogs/register_points_dialog.dart';
import 'package:silkeborgcano/models/match_round.dart';
import 'package:silkeborgcano/models/match.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/screens/match_round_screen/match_list_tile.dart';

class MatchesScreen extends StatefulWidget {
  static const String routerPath = "/matches";
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  MatchRound? _matchRound;
  List<Match> _matches = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_matchRound == null) {
      final MatchRound? matchRound = GoRouterState.of(context).extra as MatchRound?;
      if (matchRound == null) {
        debugPrint('**************MatchRound can\'t be null');
        return;
      }

      _matchRound = matchRound;
      _matches = matchRound.matches;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches Screen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.goNamed(HomeScreen.routerPath);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final m = _matches[index];
            return MatchListTile(
              court: m.courtNumber,
              team1: m.team1,
              team2: m.team2,
              onTapTeam1: () {
                RegisterPointsDialog.show(context);
              },
              onTapTeam2: () {},
              showPoints: true,
            );
          },
          separatorBuilder: (context, index) => Gap(8),
          itemCount: _matches.length,
        ),
      ),
    );
  }
}
