import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:silkeborgcano/cubits/tournament_screen_cubit/tournament_screen_cubit.dart';
import 'package:silkeborgcano/dialogs/player_name_dialog.dart';
import 'package:silkeborgcano/models/player.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/widgets/custom_text_form_field.dart';
import 'package:uuid/uuid.dart';

class TournamentScreen extends StatelessWidget {
  static const String routerPath = "/tournament";
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TournamentScreenCubit(
        Tournament(players: [], pointPerMatch: 21, rounds: []),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await PlayerNameDialog.show(context);
                      debugPrint('************Chosen $result');
                      if (context.mounted && result != null) {
                        context.read<TournamentScreenCubit>().addPlayer(
                          Player(id: Uuid().v4(), name: result, points: 0),
                        );
                      }
                    },
                    child: Text('Tilføj spiller'),
                  ),
                  BlocBuilder<TournamentScreenCubit, Tournament>(
                    builder: (context, state) {
                      return SlidableAutoCloseBehavior(
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: state.players.length,
                            itemBuilder: (context, index) {
                              final item = state.players.elementAt(index);
                              return Slidable(
                                groupTag: '1',
                                endActionPane: ActionPane(
                                  // extentRatio: 0.2,
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      autoClose: true,
                                      flex: 4,
                                      onPressed: (context) {
                                        context
                                            .read<TournamentScreenCubit>()
                                            .removePlayer(item);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                    ),
                                    SlidableAction(
                                      autoClose: true,
                                      flex: 4,
                                      onPressed: (context) {
                                        context
                                            .read<TournamentScreenCubit>()
                                            .removePlayer(item);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                    ),
                                    SlidableAction(
                                      autoClose: true,
                                      flex: 4,
                                      onPressed: (context) {
                                        context
                                            .read<TournamentScreenCubit>()
                                            .removePlayer(item);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                    ),
                                  ],
                                ),

                                child: ListTile(
                                  title: CustomTextFormField(
                                    initialValue: item.name,
                                  ),
                                  // title: Center(
                                  //   child: Text(item.name, style: TextStyle()),
                                  // ),
                                  onTap: () async {
                                    // // final result = await PlayerNameDialog.show(
                                    // //   context,
                                    // //   initialValue: item.name,
                                    // // );
                                    // debugPrint('************Chosen $result');

                                    // if (context.mounted && result != null) {
                                    //   context
                                    //       .read<TournamentScreenCubit>()
                                    //       .updatePlayer(item, result);
                                    // }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
