import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/main.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/screens/tournament_screen/tournament_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routerPath = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                objectbox.store.box<Tournament>().removeAll();
              },
              child: Text('Delete all data'),
            ),
            ElevatedButton(
              onPressed: () {
                context.goNamed(TournamentScreen.routerPath);
              },
              child: Text('Tilføj tournering'),
            ),
            StreamBuilder(
              stream: objectbox.store
                  .box<Tournament>()
                  .query()
                  .watch(triggerImmediately: true)
                  .map((query) => query.find()),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }

                final data = asyncSnapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final tournament = data[index];
                      return ListTile(
                        title: Text(tournament.name),

                        onTap: () {
                          context.goNamed(
                            TournamentScreen.routerPath,
                            extra: tournament.oid,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
