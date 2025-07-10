import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/screens/logo_screen.dart';
import 'package:resize/resize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reusable/constant.dart';
import 'screens/tab_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: primaryColor,
    primary: primaryColor,
  ),
  primaryTextTheme: GoogleFonts.robotoTextTheme(),
  textTheme: GoogleFonts.robotoTextTheme(),
);

void main() {
  runApp(
    Resize(
      size: const Size(412, 917),
      builder: () => const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget app = TabsScreen();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    var prefs = await SharedPreferences.getInstance();
    var loginData = prefs.getBool('loginData');
    if (loginData == true) {
      setState(() {
        app = const TabsScreen();
      });
    } else {
      setState(() {
        app = const LogoScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child ?? const SizedBox(),
        );
      },
      title: 'HealthMobi',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: app,
    );
  }
}
