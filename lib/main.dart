import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/localization/locales.dart';
import 'package:untitled1/screens/MainScreen.dart';
import 'package:untitled1/screens/OnboardingPage/onboarding_screen.dart';
import 'package:untitled1/screens/accountPage/settings/styles/ThemeSettingsPage.dart';
import 'package:untitled1/screens/login/login_page.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
  Widget initialRoute;

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  if (!onboardingSeen) {
    initialRoute = const OnboardingScreen();
  } else if (userId != null) {
    initialRoute = const MainScreen();
  } else {
    initialRoute = const LoginPage();
  }
  if (userId != null) {
    initialRoute = MainScreen();
  }
  await FlutterLocalization.instance.ensureInitialized();
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final Widget initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurateLocalization();
    requestNotificationPermission();
  }
  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        var result = await Permission.notification.request();
        print('Notification permission status after request: $result');
      } else {
        print('Notification permission already granted');
      }
    }
  }

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.dark;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: widget.initialRoute,
      routes: {
        '/themeSettings': (context) => ThemeSettingsPage(
          currentThemeMode: _themeMode,
          onToggleTheme: toggleTheme,
        ),
      },
    );
  }

  void configurateLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: "ru");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? local) {
    setState(() {});
  }

}
