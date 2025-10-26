import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:silkeborgcano/dialogs/yes_no_dialog.dart';
import 'package:silkeborgcano/models/tournament.dart';
import 'package:silkeborgcano/widgets/custom_icon.dart';
import 'package:silkeborgcano/widgets/custom_icon_button.dart';
import 'package:silkeborgcano/widgets/custom_list_tile.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class HomeScreenListTile extends StatefulWidget {
  final Tournament tournament;
  final VoidCallback onTap;

  const HomeScreenListTile({super.key, required this.tournament, required this.onTap});

  @override
  State<HomeScreenListTile> createState() => _HomeScreenListTileState();
}

class _HomeScreenListTileState extends State<HomeScreenListTile> {
  bool _showDeleteButton = false;

  String _getTournamentStatusText(Tournament tournament) {
    if (tournament.isTournamentEnded) {
      return 'Afsluttet den ${DateFormat('dd-MM-yyyy').format(tournament.tournamentEndUtc!.toLocal())}';
    }

    if (tournament.isTournamentActive) {
      return 'Aktiv - Starter den ${DateFormat('dd-MM-yyyy').format(tournament.tournamentStartUtc!.toLocal())}';
    }

    return 'Ikke startet';
  }

  IconData _getTournamentStatusIconData(Tournament tournament) {
    if (tournament.isTournamentEnded) {
      return Symbols.trophy;
    }

    if (tournament.isTournamentActive) {
      return Symbols.sports_volleyball;
    }

    return Symbols.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomListTile(
            onLongPress: () {
              setState(() {
                _showDeleteButton = !_showDeleteButton;
              });
            },
            onTap: widget.onTap,
            child: Row(
              children: [
                Expanded(child: CustomText(widget.tournament.name)),
                Tooltip(
                  message: _getTournamentStatusText(widget.tournament),
                  child: CustomIcon(_getTournamentStatusIconData(widget.tournament), size: CustomIconSize.s),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          child: _showDeleteButton
              ? CustomIconButton(
                  icon: Symbols.delete_forever,
                  onPressed: () async {
                    final result = await YesNoDialog.show(
                      context,
                      title: 'Slet turnering',
                      yesButtonText: 'Slet',
                      noButtonText: 'Fortryd',
                      body: 'Er du sikker på at du vil slette turneringen "${widget.tournament.name}"? Dette kan ikke fortrydes.',
                    );
                    if (result != null && result) {
                      widget.tournament.delete();
                    } else {
                      setState(() {
                        _showDeleteButton = false;
                      });
                    }
                  },
                  size: CustomIconSize.m,
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
