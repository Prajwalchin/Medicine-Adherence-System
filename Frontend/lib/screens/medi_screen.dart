import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/widget/medication_medi_screen_card.dart';
import 'package:resize/resize.dart';

class MediScreen extends StatefulWidget {
  const MediScreen({super.key});

  @override
  State<MediScreen> createState() => _MediScreenState();
}

class _MediScreenState extends State<MediScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.only(top: 19.h, left: 16.w, right: 16.w),
            child: Column(
              children: [
                Text(
                  "Your Medications",
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  spacing: 20,
                  children: [
                    MedicationMediScreenCard(
                        name: "Calpol 650mg",
                        doses: 2,
                        isafternoon: true,
                        ismorning: true,
                        isnight: true,
                        isevening: true,
                        desctiption: "After meal"),
                    MedicationMediScreenCard(
                        name: "Paracetamol 500mg",
                        doses: 1,
                        ismorning: true,
                        isnight: true,
                        desctiption: "Before meal"),
                    MedicationMediScreenCard(
                        name: "Dolo 650mg",
                        doses: 1,
                        ismorning: true,
                        desctiption: "After meal"),
                    MedicationMediScreenCard(
                        name: "Crocin 650mg",
                        doses: 1,
                        isnight: true,
                        desctiption: "After meal"),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
