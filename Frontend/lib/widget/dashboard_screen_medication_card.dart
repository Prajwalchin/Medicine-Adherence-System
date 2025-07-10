import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cards_widget.dart';

class DashboardScreenMedicationCard extends StatelessWidget {
  const DashboardScreenMedicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        margin: EdgeInsets.only(top: 20),
        selected: true,
        child: ListTile(
          title: Text(
            "Azithromycin",
            style: GoogleFonts.manrope(),
          ),
          subtitle: Text("8:00 | 1 Tablet"),
          trailing: Icon(
            Icons.circle,
            color: Colors.redAccent,
          ),
        ));
  }
}
