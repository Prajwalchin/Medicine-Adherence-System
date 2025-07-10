import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/api/api_provider.dart';
import 'package:healthmobi/models/todays_schedule_model.dart';
import 'package:healthmobi/models/user_model.dart';
import 'package:healthmobi/provider/quote_state_provider.dart';
import 'package:healthmobi/reusable/constant.dart';
import 'package:healthmobi/screens/history_screen.dart';
import 'package:healthmobi/screens/logo_screen.dart';
import 'package:healthmobi/screens/pillbox_screen.dart';
import 'package:healthmobi/screens/rewards_screen.dart';
import 'package:healthmobi/widget/cards_widget.dart';
import 'package:healthmobi/widget/skeleton_placeholder.dart';
import 'package:progress_border/progress_border.dart';
import 'package:resize/resize.dart';

// import '../models/dashboard_analytics_model.dart';
// import '../provider/dashboard_analytics_provider.dart.dart';
// import '../provider/dashboard_analytics_state_provider.dart';
import '../provider/profile_provider.dart';
import '../provider/profile_state_provider.dart';
// import '../provider/quote_provider.dart';
import '../provider/todays_schedule_provider.dart';
import '../provider/todays_schedule_state_provider.dart';
import 'chat_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    ref.read(apiProvider).getQuote();
    ref.read(apiProvider).getDashboardAnalytics();
    ref.read(apiProvider).todaysSchedule();
    ref.read(apiProvider).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todays schedule
    ApiState todaysScheduleState = ref.watch(todaysScheduleStateProvider);
    // print("Todays Schedule State: $todaysScheduleState");
    TodaysScheduleModel? todaysSchedule = ref.watch(todaysScheduleProvider);
    // print("Todays Schedule: $todaysSchedule");

    //todays quote
    ApiState quoteState = ref.watch(quoteStateProvider);
    // print("Quote State: $quoteState");
    // String? quote = ref.watch(quoteProvider);
    // print("Quote: $quote");

    //dashboard analytics
    // ApiState dashboardAnalyticsState =
    //     ref.watch(dashboardAnalyticsStateProvider);
    // print("Dashboard Analytics State: $dashboardAnalyticsState");
    // DashboardAnalyticsModel? dashboardAnalytics =
    //     ref.watch(dashboardAnalyticsProvider);
    // print("Dashboard Analytics: $dashboardAnalytics");

    //profile
    ApiState profileState = ref.watch(profileStateProvider);
    print("Profile State: $profileState");
    ProfileModel? profile = ref.watch(profileProvider);
    print("Profile: $profile");

    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ChatPage();
              }));
            },
            isExtended: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            backgroundColor: Colors.white,
            elevation: 5,
            child: Image.asset(
              'assets/images/chatbot_logo.png',
              width: 47,
              height: 47,
            ),
          ),
          backgroundColor: Colors.white,
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/chatbot_logo.png'),
                          ),
                        ),
                      ),
                      Text(
                        'HealthMobi',
                        style: GoogleFonts.manrope(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add_box_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PillBoxScreen(),
                        ));
                  },
                  title: Text(
                    'Pillbox',
                    style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.card_giftcard_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardsPage(),
                        ));
                  },
                  title: Text(
                    'Rewards',
                    style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                // ListTile(
                //   leading: Icon(Icons.book_outlined),
                //   title: Text(
                //     'Medication Diary',
                //     style: GoogleFonts.manrope(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w700,
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
                ListTile(
                  leading: Icon(Icons.history),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(),
                        ));
                  },
                  title: Text(
                    'History',
                    style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                leading: Image.asset(
                  'assets/images/chatbot_logo.png',
                ),
                title: Text(
                  "HealthMobi",
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24),
                ),
              )),
          body: Container(
            padding: EdgeInsets.only(top: 19.h, left: 16.w, right: 16.w),
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(apiProvider).todaysSchedule();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      height: 253,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/banner.jpg',
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              title: Text(
                                profileState == ApiState.loading
                                    ? "Hi"
                                    : "Hi ${profile?.name?.split(" ").first ?? "Hello"}",
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25,
                                ),
                              ),
                              subtitle: Text(
                                quoteState == ApiState.loading
                                    ? "तुमचा विचार तुमच्या भावनांपेक्षा जास्त मजबूत असला पाहिजे"
                                    : "तुमचा विचार तुमच्या भावनांपेक्षा जास्त मजबूत असला पाहिजे",
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox())
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: ProgressBorder.all(
                                  progress: 1,
                                  backgroundBorder:
                                      Border.all(color: grey, width: 5),
                                  width: 5,
                                  color: Colors.greenAccent)),
                          child: Text(
                            "7 Apr",
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // Expanded(child: SizedBox()),
                        Container(
                          alignment: Alignment.center,
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: ProgressBorder.all(
                                  progress: 0.6,
                                  backgroundBorder:
                                      Border.all(color: grey, width: 5),
                                  width: 5,
                                  color: Colors.orangeAccent)),
                          child: Text(
                            "8 Apr",
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // Expanded(child: SizedBox()),
                        Container(
                          alignment: Alignment.center,
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: ProgressBorder.all(
                                  progress: 0.3,
                                  backgroundBorder:
                                      Border.all(color: grey, width: 5),
                                  width: 5,
                                  color: Colors.redAccent)),
                          child: Text(
                            "9 Apr",
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // Expanded(child: SizedBox()),
                        Container(
                          alignment: Alignment.center,
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: ProgressBorder.all(
                                  progress: 0.8,
                                  backgroundBorder:
                                      Border.all(color: grey, width: 5),
                                  width: 5,
                                  color: Colors.greenAccent)),
                          child: Text(
                            "10 Apr",
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // Expanded(child: SizedBox()),
                        Container(
                          width: 60.w,
                          alignment: Alignment.center,
                          height: 60.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: ProgressBorder.all(
                                  progress: 0.5,
                                  backgroundBorder:
                                      Border.all(color: grey, width: 5),
                                  width: 5,
                                  color: Colors.orangeAccent)),
                          child: Text(
                            "11 Apr",
                            style: GoogleFonts.manrope(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // Expanded(child: SizedBox()),
                      ],
                    ),
                    // Divider(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Today's Schedule",
                          style: GoogleFonts.manrope(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    todaysScheduleState == ApiState.loading
                        ? SkeletonScreen()
                        : todaysScheduleState == ApiState.error
                            ? CardWidget(
                                margin: EdgeInsets.only(top: 20),
                                selected: true,
                                child: ListTile(
                                  title: Text(
                                    "Azithromycin",
                                    style: GoogleFonts.manrope(),
                                  ),
                                  subtitle: Text("8:00 AM | 1 Tablet"),
                                  trailing: Icon(
                                    Icons.circle,
                                    color: Colors.redAccent,
                                  ),
                                ))
                            : todaysSchedule?.schedule == null ||
                                    todaysSchedule!.schedule!.isEmpty
                                ? Text(
                                    "🌟 No medications today! Keep up the good health!")
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        todaysSchedule.schedule?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: index + 1 ==
                                                (todaysSchedule
                                                    .schedule?.length)
                                            ? EdgeInsets.only(bottom: 100)
                                            : EdgeInsets.all(0),
                                        child: GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: Text(
                                                      'Medication Confirmation'),
                                                  content: Text(
                                                      'Have you taken ${todaysSchedule.schedule?[index].medicineName} \n around  ${DateFormat('h:mm a').format(todaysSchedule.schedule![index].scheduledAt!)}?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        showLoadingIndicator(
                                                            context);
                                                        await ref
                                                            .read(apiProvider)
                                                            .takeMedicine(todaysSchedule
                                                                    .schedule?[
                                                                        index]
                                                                    .intakeId ??
                                                                0);
                                                        await ref
                                                            .read(apiProvider)
                                                            .todaysSchedule();
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();

                                                        // Add your logic here to mark the medication as taken
                                                      },
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: CardWidget(
                                              margin: EdgeInsets.only(top: 20),
                                              selected: true,
                                              child: ListTile(
                                                title: Text(
                                                  todaysSchedule
                                                          .schedule?[index]
                                                          .medicineName ??
                                                      "Azithromycin",
                                                  style: GoogleFonts.manrope(),
                                                ),
                                                subtitle: Text(todaysSchedule
                                                            .schedule?[index]
                                                            .scheduledAt !=
                                                        null
                                                    ? "${DateFormat('h:mm a').format(todaysSchedule.schedule![index].scheduledAt!)} | ${todaysSchedule.schedule?[index].pillcount} Tablet"
                                                    : "8:00 AM | 1 Tablet"),
                                                trailing: todaysSchedule
                                                            .schedule?[index]
                                                            .status
                                                            ?.toLowerCase() ==
                                                        "takenow"
                                                    ? Icon(Icons
                                                        .new_releases_outlined)
                                                    : Icon(Icons.circle,
                                                        color: todaysSchedule
                                                                    .schedule?[
                                                                        index]
                                                                    .status
                                                                    ?.toLowerCase() ==
                                                                "taken"
                                                            ? Colors.greenAccent
                                                            : todaysSchedule
                                                                        .schedule?[
                                                                            index]
                                                                        .status
                                                                        ?.toLowerCase() ==
                                                                    "upcoming"
                                                                ? Colors
                                                                    .orangeAccent
                                                                : Colors
                                                                    .redAccent),
                                              )),
                                        ),
                                      );
                                    }),
                    // CardWidget(
                    //     margin: EdgeInsets.only(top: 20),
                    //     selected: true,
                    //     child: ListTile(
                    //       title: Text(
                    //         "Crocin 350",
                    //         style: GoogleFonts.manrope(),
                    //       ),
                    //       subtitle: Text("8:00 am | 1 Tablet"),
                    //       trailing: Icon(
                    //         Icons.circle,
                    //         color: Colors.greenAccent,
                    //       ),
                    //     )),
                    // CardWidget(
                    //     margin: EdgeInsets.only(top: 20),
                    //     selected: true,
                    //     child: ListTile(
                    //       title: Text(
                    //         "Cold Drip",
                    //         style: GoogleFonts.manrope(),
                    //       ),
                    //       subtitle: Text("11:00 am | 2 Tablet"),
                    //       trailing: Icon(
                    //         Icons.circle,
                    //         color: Colors.yellowAccent,
                    //       ),
                    //     )),
                    // CardWidget(
                    //     margin: EdgeInsets.only(top: 20),
                    //     selected: true,
                    //     child: ListTile(
                    //       title: Text(
                    //         "Azithromycin",
                    //         style: GoogleFonts.manrope(),
                    //       ),
                    //       subtitle: Text("8:00 | 1 Tablet"),
                    //       trailing: Icon(
                    //         Icons.circle,
                    //         color: Colors.yellowAccent,
                    //       ),
                    //     ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
