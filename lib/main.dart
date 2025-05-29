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
import 'package:untitled1/screens/pinCode/PinLoginScreen.dart';
import 'package:untitled1/screens/pinCode/PinSetupScreen.dart';

import 'models/PinService.dart';

enum AppTheme { light, dark }
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  final pin = prefs.getString('user_pin');
  final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;
  final seedColorValue = prefs.getInt('theme_color') ?? Colors.blue.value;
  final Color seedColor = Color(seedColorValue);
  Widget initialRoute;

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  final pinService = PinService();
  final isPinSet = await pinService.isPinSet();

  if (!onboardingSeen) {
    initialRoute = const OnboardingScreen();
  } else if (userId == null) {
    initialRoute = const LoginPage();
  } else if (pin == null || pin.isEmpty) {
    initialRoute = PinSetupScreen();
  } else {
    initialRoute = PinLoginScreen();
  }


  await FlutterLocalization.instance.ensureInitialized();
  runApp(MyApp(initialRoute: initialRoute, seedColor: seedColor));
}

class MyApp extends StatefulWidget {
  final Widget initialRoute;
  final Color seedColor;
  const MyApp({super.key, required this.initialRoute, required this.seedColor,});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FlutterLocalization localization = FlutterLocalization.instance;
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurateLocalization();
    requestNotificationPermission();
    loadSavedTheme();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final pin = prefs.getString('user_pin');
      if (userId != null && pin != null) {
        // Показываем PIN-экран при возврате
        Future.delayed(Duration.zero, () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>  PinLoginScreen()),
          );
        });
      }
    }
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

  Future<void> saveThemeToPrefs(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', theme.name);
  }
  Future<AppTheme?> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme_mode');
    if (themeString == null) return null;
    return AppTheme.values.firstWhere((e) => e.name == themeString, orElse: () => AppTheme.light);
  }
  void loadSavedTheme() async {
    final savedTheme = await loadThemeFromPrefs();
    setState(() {
      _themeMode = savedTheme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light;
    });
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
        colorScheme: ColorScheme.fromSeed(seedColor: widget.seedColor),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: widget.seedColor, brightness: Brightness.dark),
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: widget.initialRoute,
      routes: {
        '/home': (_) => const MainScreen(),
        '/themeSettings': (context) => ThemeSettingsPage(
          currentThemeMode: _themeMode,
          onToggleTheme: toggleTheme,
        ),
        '/setupPin': (_) =>  PinSetupScreen(),
        '/loginPin': (_) =>  PinLoginScreen(),
        '/login': (_) => const LoginPage(),
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
