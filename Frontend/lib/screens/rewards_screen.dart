import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/reusable/constant.dart';
import 'package:resize/resize.dart';
import 'package:speedometer_chart/speedometer_chart.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  final List<Map<String, dynamic>> rewards = const [
    {
      "title": "10% Off Doctor Consultation",
      "icon": Icons.local_hospital,
      "color": Colors.blue
    },
    {
      "title": "Free Pillbox on 3-Month Adherence",
      "icon": Icons.medical_services,
      "color": Colors.green
    },
    {
      "title": "Exclusive HealthMobi Badge",
      "icon": Icons.emoji_events,
      "color": Colors.orange
    },
    {
      "title": "50% Off Next Medicine Order",
      "icon": Icons.shopping_cart,
      "color": Colors.purple
    },
    {
      "title": "Personalized Health Report",
      "icon": Icons.insert_chart,
      "color": Colors.red
    },
    {
      "title": "Virtual Doctor Q&A Session",
      "icon": Icons.question_answer,
      "color": Colors.teal
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Your Rewards 🎉",
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24.sp,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SpeedometerChart(
                    dimension: 200,
                    minValue: 0,
                    maxValue: 100,
                    value: 75,
                    title: Text(
                      'Medication Adherence Meter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    graphColor: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green
                    ],
                    pointerColor: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rewards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          constraints.maxWidth > 600 ? 3 : 2, // Responsive grid
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 1.2, // Adjusts size of cards
                    ),
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return RewardCard(
                        title: reward["title"],
                        icon: reward["icon"],
                        color: reward["color"],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const RewardCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              backgroundColor: Colors.white,
              title: Center(
                child: Text("Reward Details",
                    style: GoogleFonts.manrope(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
              ),
              content: Text(
                "This reward allows you to get $title.\n\nKeep adhering to your medication schedule to unlock this reward!",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 14.sp),
              ),
              actions: [
                TextButton(
                  onPressed: null, // Disabled button
                  style: TextButton.styleFrom(
                    backgroundColor: grey, // Greyed out color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    minimumSize:
                        Size(double.infinity, 40.h), // Full width button
                  ),
                  child: Text("Redeem",
                      style: GoogleFonts.manrope(
                          color: Colors.white, fontSize: 14.sp)),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        color: color,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40.sp, color: Colors.white),
              SizedBox(height: 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(color: Colors.white),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
