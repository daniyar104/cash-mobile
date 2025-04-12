import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/locales.dart';
import '../login/login_page.dart';

class MainAcountPage extends StatefulWidget {
  @override
  State<MainAcountPage> createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAcountPage> {
  late FlutterLocalization _flutterLocalization;
  late String _selectedLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _selectedLanguage = _flutterLocalization.currentLocale!.languageCode;
    print(_selectedLanguage);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Main Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(LocalData.body.getString(context)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text(LocalData.logout.getString(context)),
            ),
            Center(
              child: DropdownButton(
                value: _selectedLanguage,
                items: const [
                  DropdownMenuItem(value: "en", child: Text("English")),
                  DropdownMenuItem(value: "ru", child: Text("Russian")),
                ],
                onChanged: (value) {
                  _setLocal(value);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  void _setLocal(String? value) {
    if (value == null) return;
    if (value == "en") {
      _flutterLocalization.translate("en");
    } else if (value == "ru") {
      _flutterLocalization.translate("ru");
    }

    setState(() {
      _selectedLanguage = value!;
    });
  }
}