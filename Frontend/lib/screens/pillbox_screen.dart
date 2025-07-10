//Stateless Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resize/resize.dart';

import '../api/api_provider.dart';
import '../models/medication_course_model.dart';
import '../provider/medication_course_provider.dart';
import '../provider/medication_course_state_provider.dart';

//Stateful Widget
class PillBoxScreen extends ConsumerStatefulWidget {
  const PillBoxScreen({super.key});

  @override
  ConsumerState<PillBoxScreen> createState() => _PillBoxScreenState();
}

class _PillBoxScreenState extends ConsumerState<PillBoxScreen> {
  @override
  Widget build(BuildContext context) {
    ApiState medicationCourseState = ref.watch(medicationCourseStateProvider);
    MedicationCourseModel? medicationCourse =
        ref.watch(medicationCourseProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            scrolledUnderElevation: 0,
            title: Text(
              "PillBox",
              style: GoogleFonts.manrope(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.only(top: 19.h, left: 16.w, right: 16.w),
            child: RefreshIndicator(
              onRefresh: () async {
                ref.read(apiProvider).getMedicationCourse();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Expanded(
                    //   child: SizedBox(),
                    // ),
                    // 2x2 gridview with border to each section
                    Text(
                      // write the instruction below saying that fill the pillbox with the medicine as mentioned below
                      "Fill the pillbox with the medicine as mentioned below:",
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 2),
                
                      ),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                // Shadow should be inside the box it should look like it is inside
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(4, 4), // Shadow position
                                  blurRadius: 8, // Softness of the shadow
                                  spreadRadius: 1, // Spread of the shadow
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: const Offset(
                                      -4, -4), // Opposite shadow for 3D effect
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: medicationCourseState == ApiState.done
                                  ? Text(
                                      'Pillbox ${index + 1}\n${medicationCourse?.courses?[0].medicineCourses?[index].medicineName}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
