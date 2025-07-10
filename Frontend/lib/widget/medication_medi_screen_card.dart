import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/reusable/constant.dart';

import 'cards_widget.dart';

class MedicationMediScreenCard extends StatelessWidget {
  const MedicationMediScreenCard(
      {super.key,
      required this.name,
      this.ismorning = false,
      this.isafternoon = false,
      this.isevening = false,
      this.isnight = false,
      required this.doses,
      this.desctiption = ""});
  final String name;
  final bool ismorning;
  final bool isafternoon;
  final bool isevening;
  final bool isnight;
  final int doses;
  final String desctiption;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: EdgeInsets.all(6),
      selected: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.manrope(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  ismorning
                      ? Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            'assets/images/morning.png',
                            height: 30,
                            width: 30,
                          ),
                        )
                      : Container(),
                  isafternoon
                      ? Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            'assets/images/afternoon.png',
                            height: 25,
                            width: 25,
                          ),
                        )
                      : Container(),
                  isevening
                      ? Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Image.asset(
                            'assets/images/evening.png',
                            height: 20,
                            width: 20,
                          ),
                        )
                      : Container(),
                  isnight
                      ? Image.asset(
                          'assets/images/night.png',
                          height: 30,
                          width: 30,
                        )
                      : Container(),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time),
                  Text(
                    ' $doses doses per day',
                    style: GoogleFonts.manrope(color: secondaryfontColor),
                  )
                ],
              ),
              Text(
                desctiption,
              )
            ],
          )
        ],
      ),
    );
  }
}
